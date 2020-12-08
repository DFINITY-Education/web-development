# Module 3: Connecting to the Frontend

Now that you've completed the basic implementation of our open auction platform, it's time to link it to a frontend view! This module will guide you though the preliminary steps required to create and customize a frontend for your IC applications. 

![Frontend View](images/frontend-screenshot.png)

## Background

This module assumes basic proficiency with HTML, CSS, JavaScript, and React. We use the React framework to simplify the process of building our user interface. If you aren't familiar with React, [read through this tutorial](https://reactjs.org/tutorial/tutorial.html) created by the developers to get comfortable with using the framework - it only requires knowledge of HTML and JavaScript. 

Additionally, we have configured the starter files to work with React, but it's important to understand that you normally would have to complete this process yourself. Here is a [Dfinity SDK tutorial](https://sdk.dfinity.org/docs/developers-guide/tutorials/custom-frontend.html) that walks though the basics of setting up a frontend view for the IC, which you may find useful to skim before starting this module.

## Your Task

We have provided starter code that sets up the React framework and configures it for use with our `web_development` canister. Your job is to complete the implementation of several JavaScript methods tasked with querying and updating our backend canister. 

### Code Understanding

Now let's take a look at our frontend assets, which are all stored in the `frontend` directory. Notice that we exclusively use `.jsx` files here, which are a variation of `.js` files that extend React functionality. You can read more about this file type and it's properties on the [React page](https://reactjs.org/docs/introducing-jsx.html).

In `index.jsx` we use the standard React `render` function to render the `App` component, which we've defined in `App.jsx`, to display our whole frontend. `App.jsx` is where the real magic happens, so let's turn to that file for a quick look-through. In `App.jsx`, the first two lines import relevant React functions and libraries that we will use in our code. The next line imports our `web_development` canister, which we previously implemented in Module 2. Finally, we import two React components that we've defined in separate files, `Grid` and `AuctionNavbar`, 



#### Front-End Testing

To access the front-end of your application, open a browser and paste:

```
http://127.0.0.1:8000/?canisterId=CANISTER_ID
```

Replacing `CANISTER_ID` with the identifier of your `web_development_assets` canister. The identifier should take the general form of `cxeji-wacaa-aaaaa-aaaaa-aaaaa-aaaaa-aaaaa-q`.

