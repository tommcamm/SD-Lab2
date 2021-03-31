package edu.tomm.Laboratorio02CS.Repositories;

import edu.tomm.Laboratorio02CS.Exceptions.InvalidDataException;
import org.dizitart.no2.IndexType;
import org.dizitart.no2.objects.Id;
import org.dizitart.no2.objects.Index;
import org.dizitart.no2.objects.Indices;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

@Indices({
        @Index(value = "id", type = IndexType.Unique),
        @Index(value = "manufacturer", type = IndexType.NonUnique),
        @Index(value = "switchColor", type = IndexType.NonUnique),
})
public class Keyboard implements Serializable {
    public enum Layout{
        IT,
        EN,
        DVORAK
    }
    @Id
    private long id;
    private String manufacturer;
    private String switchColor;
    private boolean isErgonomic;
    private Layout layout;
    private List<String> comments;

    public Keyboard() {
        this.comments = new ArrayList<>();
    }

    public Keyboard(int id, String manufacturer, String switchColor, boolean isErgonomic, Layout layout) throws InvalidDataException {
        if (manufacturer.isEmpty() || switchColor.isEmpty()) throw new InvalidDataException();

        this.id = id;
        this.manufacturer = manufacturer;
        this.switchColor = switchColor;
        this.isErgonomic = isErgonomic;
        this.layout = layout;
        comments = new ArrayList<>();
    }

    public void addComment(String comment) throws InvalidDataException{
        //TODO: throw exception in case of empty comment
        if (comment.isEmpty())
            throw new InvalidDataException();
        comments.add(comment);
    }

    public void updateKeyboard(String manufacturer, String switchColor, boolean isErgonomic, Layout layout) throws InvalidDataException{
        if(manufacturer.isEmpty() || switchColor.isEmpty() || layout == null )
            throw new InvalidDataException();

        this.manufacturer = manufacturer;
        this.switchColor = switchColor;
        this.isErgonomic = isErgonomic;
        this.layout = layout;
    }

    public static List<String> layoutList(){
        ArrayList<String> layouts = new ArrayList<>();
        for (Layout iLayout:
                Layout.values()
             ) {
            layouts.add(iLayout.toString());
        }
        return layouts;
    }

    public long getId() {
        return id;
    }

    @Override
    public String toString() {
        return "Keyboard{" +
                "id=" + id +
                ", manufacturer='" + manufacturer + '\'' +
                ", switchColor='" + switchColor + '\'' +
                ", isErgonomic=" + isErgonomic +
                ", layout=" + layout +
                ", comments=" + comments +
                '}';
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getManufacturer() {
        return manufacturer;
    }

    public void setManufacturer(String manufacturer) {
        this.manufacturer = manufacturer;
    }

    public String getSwitchColor() {
        return switchColor;
    }

    public void setSwitchColor(String switchColor) {
        this.switchColor = switchColor;
    }

    public boolean getIsErgonomic() {
        return isErgonomic;
    }

    public void setErgonomic(boolean ergonomic) {
        isErgonomic = ergonomic;
    }

    public Layout getLayout() {
        return layout;
    }

    public void setLayout(Layout layout) {
        this.layout = layout;
    }

    public List<String> getComments() {
        return comments;
    }

    public void setComments(List<String> comments) {
        this.comments = comments;
    }
}
