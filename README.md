# Vinculor Flutter Test
This is the Vinculor test for Flutter engineers.
## Instructions
Fork this repository, implement the changes below and create two PRs.

**Exercise 1**
Implement the three features described below. Each feature should be in a separate commit (ideally in the same order as here). Create a single PR for all three.

**Exercise 2**
Fix the bug described below. Create a single PR for the fix.


## Exercise 1
In the TODO Editor, add the following features: 

### Feature 1:
- Group the items into two groups, completed and uncompleted
- The group titles should be: "In Progress" & "Completed"
- The "In Progress" group shouldn't show the item count


### Feature 2:
- Add a floating action button to add a new item to the list (hint: Use the `floatingAction` property on `AppScaffold`)
- The title of the floating action button should be "Add Item"
- Clicking on the button should open a new page where title and description can be entered
- There should be validation to make sure the title is entered (description is optional)

### Feature 3:
- Add a checkbox to every item indicating whether the item is completed or not
- The checkbox should be left of the text
- Clicking on this checkbox toggles the completion of the item
- Simulate this operation taking 1 second. While it is running, disable the checkbox

## Exercise 2
In the RPC tool, fix the following bug:

Steps to reproduce:
- Tap on "Open RCP Called"
- Tap on "Execute RPC Call"

What's happening:
- After the RPC call ends, the screen becomes black

What should happen:
- The app should go back to the "RPC" screen (with the "Open RCP Called" button)