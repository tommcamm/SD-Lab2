package edu.tomm.Laboratorio02CS;

import edu.tomm.Laboratorio02CS.Exceptions.InvalidDataException;
import edu.tomm.Laboratorio02CS.Repositories.Keyboard;
import org.dizitart.no2.Nitrite;
import org.dizitart.no2.objects.Cursor;
import org.dizitart.no2.objects.ObjectRepository;
import org.dizitart.no2.objects.filters.ObjectFilters;
import org.owasp.html.PolicyFactory;
import org.owasp.html.Sanitizers;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;

import static edu.tomm.Laboratorio02CS.RootServlet.DB_URL;

@WebServlet(name = "EditServlet", value = "/edit/*")
public class EditServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        if(request.getParameter("edit") != null && request.getParameter("edit").equals("1"))
            request.setAttribute("editMode", 1);
        else
            request.setAttribute("editMode", 0);

        try(Nitrite db = Nitrite.builder()
                .compressed()
                .filePath(DB_URL)
                .openOrCreate()) {

            ObjectRepository<Keyboard> keyboardStore = db.getRepository(Keyboard.class);
            Cursor<Keyboard> cursor = keyboardStore.find(ObjectFilters.eq("id", Long.parseLong(request.getPathInfo().substring(1))));
            Keyboard kb = cursor.firstOrDefault();

            if (kb == null)
                request.setAttribute("errorCode", 1);
            else
                request.setAttribute("keyboard", kb);
        } catch (NumberFormatException | NullPointerException e){
            request.setAttribute("errorCode", 1);
        }

        request.setAttribute("layouts", Keyboard.layoutList());
        request.getRequestDispatcher("/WEB-INF/edit.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        PolicyFactory policy = Sanitizers.FORMATTING;

        if(request.getParameter("op") != null && request.getParameter("op").equals("0")) {
            try (Nitrite db = Nitrite.builder()
                    .compressed()
                    .filePath(DB_URL)
                    .openOrCreate()) {
                ObjectRepository<Keyboard> keyboardStore = db.getRepository(Keyboard.class);
                Keyboard kb = keyboardStore.find(ObjectFilters.eq("id",
                        Long.parseLong(request.getPathInfo().substring(1))
                )).firstOrDefault();
                kb.addComment(policy.sanitize(request.getParameter("commentInput")));
                keyboardStore.update(kb);

            } catch (InvalidDataException | NumberFormatException e) {
                request.setAttribute("errorCode", 2);
            }

        } else if (request.getParameter("op") != null && request.getParameter("op").equals("1")){
            try (Nitrite db = Nitrite.builder()
                    .compressed()
                    .filePath(DB_URL)
                    .openOrCreate()){
                ObjectRepository<Keyboard> keyboardStore = db.getRepository(Keyboard.class);
                Keyboard kb = keyboardStore.find(ObjectFilters.eq("id",
                        Long.parseLong(request.getPathInfo().substring(1))
                )).firstOrDefault();
                kb.updateKeyboard(request.getParameter("manufacturerInput"),
                        request.getParameter("switchColorInput"),
                        request.getParameter("isErgonomicInput") != null,
                        Keyboard.Layout.valueOf(request.getParameter("layoutInput"))
                );
                keyboardStore.update(kb);
            } catch (InvalidDataException | NumberFormatException e) {
                request.setAttribute("errorCode", 2);
            }
        }

        doGet(request, response);
    }
}
