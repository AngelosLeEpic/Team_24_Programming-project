/**
 * WidgetDropDown class represents a dropdown widget.
 * It extends the Widget class.
 */
class WidgetDropDown extends Widget {

  // Array to hold the elements of the dropdown
  String[] elements;

  // ArrayList to hold valid data filtered based on user input
  ArrayList<String> validData = new ArrayList<String>();

  // User input string for filtering dropdown options
  String Search = "";

  // Boolean to indicate if the dropdown is active
  boolean amIActive = false;

  // Number of dropdown elements to display at a time
  int numOfDropsToDisplay = 5;

  // Selected value in the dropdown
  String selectedValue = "";

  // Font for rendering text in the dropdown
  PFont font;

  // Default text to display when no value is selected
  String defaultText;

  // Index to track scrolling in the dropdown
  int scrollIndex = 0;

  /**
   * Constructor for WidgetDropDown class.
   * Initializes dropdown properties and initializes valid data list.
   *
   * @param x         X-coordinate of the dropdown
   * @param y         Y-coordinate of the dropdown
   * @param wide      Width of the dropdown
   * @param high      Height of the dropdown
   * @param myFont    Font for rendering text in the dropdown
   * @param input     Array of strings representing dropdown elements
   * @param defaul    Default text to display when no value is selected
   */
  WidgetDropDown(int x, int y, int wide, int high, PFont myFont, String[] input, String defaul) {
    super(x, y, wide, high, 0);
    font = myFont;
    elements = input;
    for (String unit : elements) {
      validData.add(unit);
    }
    defaultText = defaul;
  }


  /**
   * Initiates the dropdown, updating search results and setting dropdown status to active.
   */
  void initiativeDropDown() {
    searchBarUpdated(); // Update search results
    isDropDownActive = true; // Set dropdown active status
    this.amIActive = true; // Set internal active status
  }


  /**
   * Removes the dropdown and resets relevant boolean values for future interaction.
   */
  void removeDropDown() {
    scrollIndex = 0; // Reset scroll index
    isDropDownActive = false; // Set dropdown active status to false
    this.amIActive = false; // Set internal active status to false
    Search = ""; // Clear search input
  }


/**
 * Changes the scroll index based on how the user scrolled.
 * 
 * @param i The amount to scroll by.
 */
void scroll(int i) {
    scrollIndex += i; // Increment scroll index by the provided amount

    // Ensure scroll index does not go below 0
    if (scrollIndex < 0) {
        scrollIndex = 0;
    }

    // Ensure scroll index does not exceed the valid range for displaying dropdown items
    if (scrollIndex > -numOfDropsToDisplay + validData.size()) {
        scrollIndex = validData.size() - numOfDropsToDisplay;
    }

    // Reset scroll index if the number of valid data items is less than or equal to the number of dropdown items to display
    if (validData.size() <= scrollIndex) {
        scrollIndex = 0;
    }

    // Reset scroll index if the number of valid data items is less than or equal to 5
    if (validData.size() <= 5) {
        scrollIndex = 0;
    }
}


  /**
   * Renders the dropdown button and its associated dropdown list.
   */
  void render() {
    fill(screen.SECONDARY_COLOR); // Set fill color for the button background
    rect(xpos, ypos, wide, high, 10, 10, 0, 0); // Render the button background with rounded corners

    fill(screen.TEXT_COLOR); // Set fill color for text

    if (amIActive) { // If the dropdown is active
      fill(screen.TEXT_COLOR); // Set fill color for text
      text(Search, xpos + 5, ypos + high / 2); // Render the search text in the dropdown button
      renderDrops(); // Render the dropdown list
    } else { // If the dropdown is not active
      fill(screen.TEXT_COLOR); // Set fill color for text
      textAlign(LEFT, CENTER); // Set text alignment
      text(selectedValue, xpos + 5, ypos + high / 3); // Render the selected value in the dropdown button
    }
  }


  /**
   * Renders the dropdown list of the dropdown menu.
   */
  void renderDrops() {
    for (int i = 0; i < numOfDropsToDisplay; i++) {
      try {
        fill(screen.TEXT_COLOR); // Set fill color for text
        textAlign(LEFT, CENTER); // Set text alignment
        text(validData.get(i + scrollIndex), xpos + 5, ypos + high / 3 + high * (i + 1)); // Render the text of the dropdown item
        fill(screen.TERTIARY_COLOR); // Set fill color for the dropdown item background
        textFont(TextBoxFont); // Set the font for the dropdown item text
        rect(xpos, ypos + high * (i + 1), wide, high); // Render the background of the dropdown item
        fill(screen.TEXT_COLOR); // Set fill color for text
        text(validData.get(i + scrollIndex), xpos + 5, ypos + high / 3 + high * (i + 1)); // Render the text of the dropdown item again over the box
      }
      catch (Exception e) {
        break; // Exit the loop if there are no more elements to display
      }
    }
  }


  /**
   * Handles the click event for the dropdown.
   */
  void isClicked() {
    if (isMouseover() && !amIActive) {
      initiativeDropDown(); // Activate the dropdown if the mouse is over the dropdown button and it's not already active
    } else if (amIActive && isMouseover()) { // If the dropdown is active and the mouse is over the dropdown button
      selectedValue = defaultText; // Reset the selected value to the default text
      removeDropDown(); // Remove the dropdown
    } else if (amIActive) { // If the dropdown is active
      for (int i = 0; i < numOfDropsToDisplay; i++) {
        if ((xpos < mouseX && xpos + wide > mouseX) && (ypos + (high * (i + 1)) < mouseY && ((ypos + (high * (i + 1))) + high > mouseY))) {
          // If the mouse is over an element in the dropdown list
          try {
            selectedValue = validData.get(i + scrollIndex); // Set the selected value to the clicked element
            removeDropDown(); // Remove the dropdown
            break; // Exit the loop
          }
          catch (Exception e) {
            selectedValue = defaultText; // Reset the selected value to the default text
            removeDropDown(); // Remove the dropdown
            break; // Exit the loop
          }
        }
      }
      removeDropDown(); // Remove the dropdown
    }
  }


  /**
   * Allows the dropdown to accept text input when active and filters the dropdown elements based on the user's input.
   * If the user presses backspace, it removes the last character from the search query and updates the dropdown.
   * If the input is a character, it converts it to uppercase and adds it to the search query, then updates the dropdown.
   */
  void searchBarinput(char input) {
    try {
      if ((int) input == 8) { // If the user pressed backspace
        backSpacePressed(); // Remove the last character from the search query
        searchBarUpdated(); // Update the dropdown
      } else {
        input = Character.toUpperCase(input); // Convert the input character to uppercase
        Search += input; // Add the character to the search query
        searchBarUpdated(); // Update the dropdown
      }
      scrollIndex = 0; // Reset the scroll index
    }
    catch (Exception e) {
      // Do nothing if we could not process the user input
      // Most likely the user pressed an input that we did not expect,
      // and failed at the Character.toUpperCase line, in which case we don't care
    }
  }


  /**
   * Filters the dropdown elements based on the search query entered by the user.
   * It clears the validData list and iterates through the elements array.
   * If an element starts with the search query, it adds the element to the validData list.
   */
  void searchBarUpdated() {
    validData.clear(); // Clear the validData list
    for (String element : elements) {
      if (element.startsWith(Search)) { // If the element starts with the search query
        validData.add(element); // Add the element to the validData list
      }
    }
  }


  /**
   * Executes when the user presses the backspace key while typing on the drop-down search bar.
   * Removes the last character from the search query if the user presses backspace.
   * If the search query is empty or null, it does nothing.
   */
  void backSpacePressed() {
    try {
      if (Search != null && !Search.isEmpty()) {
        Search = Search.substring(0, Search.length() - 1); // Remove the last character from the search query
      }
    }
    catch (Exception e) {
      Search = ""; // Reset the search query if an exception occurs
      // The user used backspace even though nothing is written, do nothing
    }
  }
}
