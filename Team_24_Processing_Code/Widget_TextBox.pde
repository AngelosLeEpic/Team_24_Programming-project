/**
 * Represents a text box widget in the application interface, derived from the Widget class.
 * Inherits properties and methods from the Widget class and adds text box-specific functionality.
 */
class WidgetTextBox extends Widget {

  String textValue;         // The current text value in the text box
  String normal;            // The default text to display when the text box is empty
  boolean active = false;   // Indicates whether the text box is active (focused)
  String num1;              // Placeholder for numerical input (if applicable)
  WIDGET_TEXT_TYPE myType;  // Type of text box (e.g., numeric, alphanumeric)
  PFont font;               // Font used for rendering text in the text box

  /**
   * Constructs a new WidgetTextBox object with specified position, size, font, default text, and type.
   *
   * @param x The x-coordinate of the text box.
   * @param y The y-coordinate of the text box.
   * @param w The width of the text box.
   * @param h The height of the text box.
   * @param R The roundness of the text box corners.
   * @param font The font used for rendering text in the text box.
   * @param defaul The default text to display when the text box is empty.
   * @param type The type of the text box (e.g., numeric, alphanumeric).
   */
  WidgetTextBox(int x, int y, int w, int h, int R, PFont font, String defaul, WIDGET_TEXT_TYPE type) {
    super(x, y, w, h, R); // Calls the constructor of the superclass (Widget) to initialize properties
    this.font = font;
    normal = defaul;
    textValue = defaul;
    myType = type;
  }

  /**
   * Renders the text box on the screen with its current state and value.
   * If the text box is active, it renders with a different color.
   * If the text box type is DATE and is active, it appends "/01/2022" to the displayed textValue.
   * If the text box type is DATE and the textValue is "DD/MM/YYYY", it does not append "/01/2022".
   */
  void render() {
    if (active) {
      fill(255); // Color when active (alternative)
    } else {
      fill(200);
      //fill(screen.INACTIVE_TEXT_BOX); // Color when inactive
    }
    rect(xpos, ypos, wide, high, roundness); // Draw the text box background rectangle

    fill(screen.TEXT_COLOR); // Set the fill color for text
    textAlign(LEFT, CENTER); // Set text alignment to left and center
    textFont(TextBoxFont);   // Set the font for rendering text

    // Check if the text box type is DATE and if the text box is active,
    // or if the textValue is not "DD/MM/YYYY" and the type is DATE
    if ((myType == WIDGET_TEXT_TYPE.DATE && active || (textValue != "DD/MM/YYYY")&& myType == WIDGET_TEXT_TYPE.DATE)) {
      text(textValue + "/01/2022", xpos + 5, ypos + high/3); // Render textValue with appended "/01/2022"
    } else
    {
      text(textValue, xpos + 5, ypos + high/3); // Render textValue without appending
    }
  }

  /**
   * Processes the user input based on the current state and type of the text box.
   * If the text box is active, it handles the user's key press appropriately.
   * The type of the textbox that the input is using determines what input will actually be accepted and what will not be accepted
   * @param key The character representing the user's input.
   */
  void input(char key)
  {
    if (active)// Check if the text box is active
    {
      switch(myType) // Switch based on the type of the text box
      {
      case TIME:
        switch(key)
        {
        case 8: // Backspace key
          backSpacePressed(); // Handle backspace input
          break;
        case 10: // Enter key
          active = false; // Deactivate the text box
          break;
        case '0':
        case '1':
        case '2':
        case '3':
        case '4': // Numerical keys
        case '5':
        case '6':
        case '7':
        case '8':
        case '9':
          textValue += key; // Append the numerical character to the textValue
          addColonAndCheckCompletion(); // Add colon if necessary and check completion
          break;
        default:
          addColonAndCheckCompletion(); // Add colon and check completion for other keys
          break; // We do not allow the user to input anything but acceptable characters
        }

        break;
      case DATE:
        switch(key)
        {
        case 8: // Backspace key
          backSpacePressed(); // Handle backspace input
          break;
        case 10: // Enter key
          active = false; // Deactivate the text box
          if (!isStringValid()) // Check if the input string is valid
          {
            userInputInvalid(); // Notify if the input string is invalid and nullify it
          }
          addColonAndCheckCompletion(); // Add colon and check completion
          break;
        case '0':
        case '1':
        case '2':
        case '3':
        case '4': // Numerical keys
        case '5':
        case '6':
        case '7':
        case '8':
        case '9':
          textValue += key;
          if (textValue.length() == 2) {
            active = false; // Deactivate the text box if the user has put in the date
            if (!isStringValid()) // Check if the input string is valid
            {
              userInputInvalid(); // Notify if the input string is invalid and nullify it
            }
          }
          break;
        default:
          break;
        }
      }
    }
  }

  /**
   * Checks if the text box has been clicked by the user.
   * If the mouse is over the text box, it activates the text box for input and resets the text value.
   * Otherwise, it deactivates the text box and checks if the input string is valid.
   */
  void isClicked() {
    if (isMouseover()) { // Check if the mouse is over the text box
      active = true; // Activate the text box
      textValue = ""; // Reset textValue so the user can provide new input
    } else { // If the mouse is not over the text box
      active = false; // Deactivate the text box
      if (isStringValid()) { // Check if the input string is valid
        // If the input string is valid, do nothing
      } else {
        userInputInvalid(); // Notify if the input string is invalid
      }
    }
  }

  /**
   * Method to be executed if the user presses the backspace key while typing in the text box.
   * Removes the last character from the text value if the user presses backspace.
   * If the text value is empty and the user presses backspace, it does nothing.
   */
  void backSpacePressed() {
    try {
      textValue = textValue.substring(0, textValue.length() - 1); // Remove the last character if the user presses backspace
    }
    catch (Exception e) {
      textValue = ""; // If an exception occurs (e.g., textValue is empty), set textValue to empty string
      // The user used backspace even though nothing is written, do nothing
    }
  }

  /**
   * Adds a colon to the user input if the length of the text value is 2 (for HH) to format it as HH:MM.
   * Checks if the user has completed a full input (HH:MM format) and automatically deactivates the text box if so.
   * If the input is not valid, resets the text value to the default value.
   */
  void addColonAndCheckCompletion() {
    if (textValue.length() == 2) { // Check if the user has entered HH
      textValue += ":"; // Add a colon to format as HH:MM
    }
    if (textValue.length() == 5) { // Check if the user has completed HH:MM
      active = false; // Deactivate the text box
      if (!isStringValid()) { // Check if the input is valid
        textValue = normal; // Reset text value to default if input is not valid
      }
    }
  }

  /**
   * Deactivates the text box and resets the text value to the default value if the user input is not valid.
   * This method should be called only when the user has given their full input.
   */
  void userInputInvalid() {
    active = false; // Deactivate the text box
    textValue = normal; // Reset text value to the default value
  }

  /**
   * Checks if the user input (textValue) is a valid input for the button type of this object.
   *
   * @return true if the input is valid, false otherwise.
   */
  boolean isStringValid() {
    if (myType == WIDGET_TEXT_TYPE.TIME) {
      if (textValue.length() != 5) {
        return false; // Invalid length for time input
      }
      String[] parts = textValue.split(":");
      if (parts.length == 2) { // Ensure there are two parts
        try {
          int hours = Integer.parseInt(parts[0]);
          int minutes = Integer.parseInt(parts[1]);

          // Check if hours and minutes are in valid ranges
          if (hours >= 0 && hours <= 23 && minutes >= 0 && minutes <= 59) {
            return true; // Time is valid
          }
        }
        catch (NumberFormatException e) {
          return false; // Unable to parse integers from the input
        }
      } else {
        return Integer.parseInt(textValue) >= 0 && Integer.parseInt(textValue) <= 31; // Assuming the input represents a day of the month
      }
    } else { // Button type is date
      try {
        return (Integer.parseInt(textValue) <= 31); // Check if the input is a valid day of the month
      }
      catch (Exception e) {
        return false; // Unable to parse integer from the input
      }
    }
    return false; // Unreachable code, added for completeness
  }

  /**
   * Returns a string representation of the button's input.
   *
   * @return A string representation of the user input processed based on the button type.
   *         For a time input, it returns the input without colons and leading/trailing whitespaces.
   *         For a date input, it returns a formatted date string in the format "YYYY-MM-DD".
   *         Returns null if the input is empty, null, or matches the default value.
   */
  String giveProcessedUserInput() {
    if (myType == WIDGET_TEXT_TYPE.TIME) {
      return textValue.replace(":", "").trim(); // Remove colons and leading/trailing whitespaces
    } else {
      try {
        if (textValue == "" || textValue == null || textValue == normal) {
          return null; // Return null if the input is empty, null, or matches the default value
        }
        String Day = textValue;
        Day = (("2022/01/" + Day)); // Assuming the input represents a day of the month
        Day = Day.replace("/", "-"); // Format the date string as "YYYY-MM-DD"
        return Day;
      }
      catch (Exception e) {
        return null; // Return null if any exception occurs during processing
      }
    }
  }
}
