

# App Overview

Your app allows users to:

1. **Create and manage organizations:** Each user can create their own organization, manage it, and invite others to join. Within organizations, users can create groups to manage different teams.

2. **Design and build landing pages or apps:**
   - **Landing Pages** are typically for introducing businesses with blocks for text, images, and other media.
   - **Apps** are created for employees to manage and use, with features like widgets (datagrids, kanban boards, file managers, etc.) for more complex functionality.

3. **Fully customizable pages and apps:**
   - **Property List:** Allows users to customize all visual aspects (like text, colors, and images) as well as sizes and other styles.
   - **Widgets:** Widgets can connect to various types of databases (SQL, NoSQL, etc.), allowing for CRUD operations and automation within the app.

## Widgets, Databases, and Automation

Widgets in your app are not just static components but highly dynamic, allowing for connections to databases and enabling CRUD (Create, Read, Update, Delete) operations.

1. **Database Connection:**
   - Users can connect their widgets to existing databases or create new ones through the app.
   - Once connected, widgets allow users to manage their data seamlessly via CRUD operations, meaning they can easily retrieve (read), add (create), modify (update), and delete data directly through the app.

2. **Automation:**
   - The app allows for event-driven automation. For example, if new data is entered into a database, an automated process can be triggered (such as sending a notification, performing a CRUD operation, or sending an email). This makes the app flexible in terms of workflow automation.

## allyoucancloudplugin: The NPM Package

The allyoucancloudplugin npm package acts as a key player in managing the interaction between widgets, databases, and backend automation.

- **Wrapper Functions:** When a widget is wrapped with the allyoucancloudplugin, a list of functions is made available via AyccPlugin (imported using React's context API).

- **How it works:**
  1. **Backend Communication:** The package handles communication between the widget and your backend. When a widget needs to perform CRUD operations or connect to a database, the wrapper sends requests to the backend, which in turn handles the interaction with the database or triggers automations.
  
  2. **Property Changes:** The package also handles changes in the widget properties. For example, when a user customizes styles or settings within the property list, those changes are saved to the database. On refreshing the app or the widget, the latest properties are retrieved from the database to ensure that the widget's state is always up to date.
  
  3. **Automations:** The wrapper facilitates communication with your backend to set up any event-driven workflows (e.g., data changes that trigger automations).

## Explanation of Database and Widget Relations

The key relationship between the widgets and the database is established via the npm package. The widgets serve as the UI components that users interact with, while the npm package connects these widgets to the backend, which directly communicates with the database. Here's how this works:

1. **Step 1: Widget Interaction**
   - A user interacts with a widget (for example, entering data into a form within a widget).

2. **Step 2: Backend Communication**
   - The widget, wrapped by the allyoucancloudplugin, uses the built-in functions to send a request to the backend. This request could be for creating a new entry in the database or retrieving data.

3. **Step 3: Database Operation**
   - The backend processes the request, interacts with the database (e.g., creates new data, retrieves, updates, or deletes data), and sends the response back to the widget.

4. **Step 4: Automation (If any)**
   - If a condition is met (like new data being created), the automation is triggered, for example, sending an alert, an email, or executing additional database operations.

5. **Step 5: Property Changes Sync**
   - Any property changes made to the widget (styles, data sources, etc.) are saved to the database. Upon refreshing or reopening the app, these properties are fetched from the database, ensuring that the user sees the most up-to-date version of the widget.

## Example: Using allyoucancloudplugin

Here's a brief code sample that shows how a widget might be wrapped with the allyoucancloudplugin and use the available functions for CRUD operations:

```jsx
import React, { useContext, useEffect } from 'react';
import { AyccPlugin } from 'allyoucancloudplugin';

const MyCustomWidget = () => {
  // Access functions provided by AyccPlugin
  const { createRecord, updateRecord, deleteRecord, fetchData } = useContext(AyccPlugin);

  useEffect(() => {
    // Fetch data when the component is loaded
    fetchData('myDatabaseTable').then(data => {
      console.log('Fetched Data:', data);
    });
  }, [fetchData]);

  const handleCreate = () => {
    // Create a new record in the database
    createRecord('myDatabaseTable', { name: 'New Record', value: 'Some Value' });
  };

  const handleUpdate = (id) => {
    // Update a record in the database
    updateRecord('myDatabaseTable', id, { value: 'Updated Value' });
  };

  const handleDelete = (id) => {
    // Delete a record from the database
    deleteRecord('myDatabaseTable', id);
  };

  return (
    <div>
      <button onClick={handleCreate}>Create Record</button>
      <button onClick={() => handleUpdate('123')}>Update Record</button>
      <button onClick={() => handleDelete('123')}>Delete Record</button>
    </div>
  );
};

export default MyCustomWidget;
```

## Key Points to Remember

1. **Separation of Concerns:** Keep UI (widgets) separate from the business logic (backend and automations). This ensures modularity and easier maintenance.

2. **Use Context API:** The AyccPlugin leverages React's Context API to provide access to the necessary functions (like CRUD operations and automations) across the entire widget.

3. **Efficient Backend Communication:** Ensure that requests to the backend are minimal and efficient. Batch data requests where possible and use pagination for large data sets.

4. **Security Best Practices:** Make sure that all API requests are authenticated, and data validation is handled both at the frontend and backend levels.

# Auth Keycloak

Our app utilizes Keycloak for authentication and realm management. The following documentation explains how to handle user registration, realm creation, group management, and user invitations.

## 1. User Registration and Realm Creation

When a user registers, the app automatically creates a new Keycloak realm based on their organization name. The user is designated as the admin of this new realm. This process occurs on the backend, using the following flow:

### Flow Overview:

- **Input:** User registration details including organization name, email, and password.

- **Backend Process:**
  - A new organization entity is created in the database.
  - A Keycloak realm is created for the organization.
  - The user is assigned as the realm admin.

### Code Snippet:

```javascript
const addOrganizationMutation = {
  type: OrganizationType,
  args: {
    owner: { type: GraphQLID },
    domain: { type: GraphQLID },
    name: { type: GraphQLString },
    industry: { type: GraphQLString },
    language: { type: GraphQLString },
    currency: { type: GraphQLString },
    timeZone: { type: GraphQLString },
    email: { type: GraphQLString },
    password: { type: GraphQLString },
  },
  async resolve(parent, args, context) {
    // Create organization entity
    let organization = new Organization({
      _id: new mongoose.Types.ObjectId(),
      owner: args.owner,
      domain: args.domain,
      name: args.name,
      industry: args.industry,
      language: args.language,
      currency: args.currency,
      timeZone: args.timeZone,
    });

    // Authentication and realm creation in Keycloak
    const data = {
      client_id: "admin-cli",
      username: "admin",
      password: "Zvs5nq8UpiipC1T",
      grant_type: "password",
    };

    const newRealm = {
      realm: `${args.name}-${organization._id}`,
      displayName: args.name,
      users: [
        {
          username: "admin",
          firstName: "Realm",
          lastName: "Admin",
          email: args.email,
          enabled: true,
          credentials: [{ type: "admin", value: "admin" }],
          clientRoles: { "realm-management": ["realm-admin"] },
        },
      ],
    };

    try {
      // Retrieve access token
      const response = await axios.post(
        "https://sso.allyoucancloud.com/realms/master/protocol/openid-connect/token",
        data,
        { headers: { 'Content-Type': 'application/x-www-form-urlencoded' } }
      );

      const token = response.data.access_token;

      // Create realm in Keycloak
      await axios.post(
        "https://sso.allyoucancloud.com/admin/realms",
        newRealm,
        { headers: { Authorization: `Bearer ${token}`, 'Content-Type': 'application/json' } }
      );

      // Save organization in database
      return await organization.save();
    } catch (error) {
      console.log(error);
      throw new Error("Error creating realm or organization");
    }
  },
};
```

### Backend Flow Explanation:

1. **Organization Creation:** The app receives the user's information and creates an organization entry in the database.

2. **Realm Creation:** Using Keycloak API, a realm is created with the organization's name and a unique ID. The user is automatically assigned as the realm admin.

3. **Admin Assignment:** The user who registered is designated as the administrator of the new realm.

## 2. Group Creation in a Realm

Once a realm is created, users can create groups within the organization. Each group corresponds to a new Keycloak group within the respective realm.

### Flow Overview:

- **Input:** Organization ID and group name.

- **Backend Process:**
  - A group entity is created in the database.
  - The group is added to the Keycloak realm for the organization.

### Code Snippet:

```javascript
const addGroupMutation = {
  type: GroupType,
  args: {
    org: { type: GraphQLID },
    name: { type: GraphQLString },
  },
  async resolve(parent, args, context) {
    let group = new Group({
      _id: new mongoose.Types.ObjectId(),
      org: args.org,
      name: args.name,
    });

    const organization = await Organization.findOne({ _id: args.org });
    let orgName = `${organization?.name}-${organization?._id}`;

    const data = {
      client_id: "admin-cli",
      username: "admin",
      password: "admin",
      grant_type: "password",
    };

    try {
      // Retrieve access token
      const response = await axios.post(
        `https://sso.allyoucancloud.com/realms/${orgName}/protocol/openid-connect/token`,
        data,
        { headers: { 'Content-Type': 'application/x-www-form-urlencoded' } }
      );

      const token = response.data.access_token;

      // Create group in Keycloak
      await axios.post(
        `https://sso.allyoucancloud.com/admin/realms/${orgName}/groups`,
        { name: args.name },
        { headers: { Authorization: `Bearer ${token}`, 'Content-Type': 'application/json' } }
      );

      // Save group in database
      return await group.save();
    } catch (error) {
      console.log(error);
      throw new Error("Error creating group");
    }
  },
};
```

## 3. User Invitation to Groups

Admins can invite new or existing users to join groups within the organization. If the user is new, they are registered in Keycloak, and then added to the appropriate group.

### Flow Overview:

- **Input:** User details including name, email, and group assignment.

- **Backend Process:**
  - If the user is new, they are created in the Keycloak realm.
  - If the user exists, they are added to the specified group in Keycloak.

### Code Snippet:

```javascript
const addUserMutation = {
  type: UserType,
  args: {
    name: { type: GraphQLString },
    email: { type: GraphQLString },
    org: { type: GraphQLID },
    group: { type: GraphQLString },
  },
  async resolve(parent, args, context) {
    const organization = await Organization.findOne({ _id: args.org });
    let orgName = `${organization?.name}-${organization?._id}`;

    const data = {
      client_id: "admin-cli",
      username: "admin",
      password: "admin",
      grant_type: "password",
    };

    try {
      // Retrieve access token
      const response = await axios.post(
        `https://sso.allyoucancloud.com/realms/${orgName}/protocol/openid-connect/token`,
        data,
        { headers: { 'Content-Type': 'application/x-www-form-urlencoded' } }
      );

      const token = response.data.access_token;

      // Invite or add user to Keycloak group
      const group = await Group.findOne({ _id: args.group });

      await axios.post(
        `https://sso.allyoucancloud.com/admin/realms/${orgName}/users`,
        {
          username: args.email,
          email: args.email,
          enabled: true,
        },
        { headers: { Authorization: `Bearer ${token}`, 'Content-Type': 'application/json' } }
      );

      return await group.save();
    } catch (error) {
      console.log(error);
      throw new Error("Error inviting user to group");
    }
  },
};
```

# Client DB Workflow

