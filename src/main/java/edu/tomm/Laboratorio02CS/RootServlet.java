package edu.tomm.Laboratorio02CS;

import edu.tomm.Laboratorio02CS.Repositories.Keyboard;
import edu.tomm.Laboratorio02CS.Exceptions.InvalidDataException;
import org.dizitart.no2.FindOptions;
import org.dizitart.no2.Nitrite;
import org.dizitart.no2.SortOrder;
import org.dizitart.no2.exceptions.UniqueConstraintException;
import org.dizitart.no2.objects.Cursor;
import org.dizitart.no2.objects.ObjectRepository;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "RootServlet", urlPatterns = {"/index.html"})
public class RootServlet extends HttpServlet {
    /*
     Location of Database file, edit this constant for using a different file location,
     currently is in the temp directory.
    */
    public static final String DB_URL  = System.getProperty("java.io.tmpdir") + "\\test.db";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // The Nitrite NOSQL database is in use with this project
        try (Nitrite db = Nitrite.builder()
                .compressed()
                .filePath(DB_URL)
                .openOrCreate()){

        ObjectRepository<Keyboard> keyboardStore = db.getRepository(Keyboard.class);
        Cursor<Keyboard> cursor = keyboardStore.find(FindOptions.sort("id", SortOrder.Ascending));

        List<Keyboard> keyboards = cursor.toList();
            request.setAttribute("keyboards", keyboards);
            request.setAttribute("layouts", Keyboard.layoutList());
        }

        request.getRequestDispatcher("/WEB-INF/index.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try (Nitrite db = Nitrite.builder()
                .compressed()
                .filePath(DB_URL)
                .openOrCreate()) {
            ObjectRepository<Keyboard> keyboardStore = db.getRepository(Keyboard.class);
            keyboardStore.insert(new Keyboard(Integer.parseInt(request.getParameter("idInput")),
                    request.getParameter("manufacturerInput"),
                    request.getParameter("switchColorInput"),
                    request.getParameter("isErgonomicInput") != null,
                    Keyboard.Layout.valueOf(request.getParameter("layoutInput"))));

            request.setAttribute("successCode", 1);
        } catch (NumberFormatException e) {
            request.setAttribute("errorCode", 1);
        } catch (InvalidDataException e) {
            request.setAttribute("errorCode", 2);
        } catch (UniqueConstraintException e) {
            request.setAttribute("errorCode", 3);
        }
        doGet(request, response);
    }
}
