/**
 * Represents a graphical widget in the application interface, such as a button.
 */
class Widget {

  boolean active = false;     // Indicates whether the widget is active
  int xpos, ypos;             // Position of the widget
  int wide, high;             // Size of the widget
  String label = "";          // Text label of the widget
  int roundness;              // Roundness of the widget (for buttons)

  /**
   * Constructs a new Widget object with specified position, size, and roundness.
   *
   * @param x The x-coordinate of the widget.
   * @param y The y-coordinate of the widget.
   * @param w The width of the widget.
   * @param h The height of the widget.
   * @param R The roundness of the widget (for buttons).
   */
  Widget(int x, int y, int w, int h, int R) {
    xpos = x;
    ypos = y;
    wide = w;
    high = h;
    roundness = R;
  }

  /**
   * Checks if the mouse cursor is hovering over the widget.
   *
   * @return true if the mouse cursor is over the widget, otherwise false.
   */
  boolean isMouseover() {
    return (xpos < mouseX && xpos + wide > mouseX) && (ypos < mouseY && ypos + high > mouseY);
  }
  
  boolean isInputValidtimeRange(String input){ // Checks if the inputed "XX:XX" string is a vald 24 hour clock representation
    try{
      String regex = "^(?:[01]?[0-9]|2[0-3]):[0-5][0-9]$";
      Pattern pattern = Pattern.compile(regex);
      Matcher matcher = pattern.matcher(input);
      return matcher.matches();
    } catch (Exception e)
    {
      return false; //if anytihng goes wrong with this most likely the user's input is bad
    }
  }
}
