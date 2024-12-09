document.addEventListener("DOMContentLoaded", () => {
    const userTableBody = document.querySelector(".user-table tbody");

    // Function to fetch users from the API
    async function fetchUsers() {
        try {
            const userToken = localStorage.getItem('authToken'); // Retrieve the token from local storage
            const response = await fetch('http://192.168.1.7:8080/api/users', { // Ensure this endpoint is correct
                method: 'GET',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${userToken}`, // Use the token for authorization
                },
            });

            if (!response.ok) {
                throw new Error('Error fetching users: ' + response.statusText);
            }

            const responseData = await response.json();
            renderUsers(responseData.data); // Pass the users to render function
        } catch (error) {
            console.error('Fetch error:', error);
            alert('Could not fetch users. Please try again later.');
        }
    }

    // Function to render the fetched users in the table
    function renderUsers(users) {
        userTableBody.innerHTML = ''; // Clear existing rows
        users.forEach((user, index) => {
            const newRow = document.createElement("tr");
            newRow.innerHTML = `
                <td>${index + 1}</td>
                <td>${user.name}</td>
                <td>${user.email}</td>
                <td>${user.role}</td>
                <td>
                    <button class="edit-btn" data-id="${user._id}">Edit</button>
                    <button class="delete-btn" data-id="${user._id}">Delete</button>
                </td>
            `;
            userTableBody.appendChild(newRow);
        });
    }

    // Call fetchUsers to load users when the page initially loads
    fetchUsers();

    // Handle user actions: Edit and Delete
    userTableBody.addEventListener("click", async (event) => {
        const userId = event.target.dataset.id;

        if (event.target.classList.contains("delete-btn")) {
            if (confirm("Are you sure you want to delete this user?")) {
                await deleteUser(userId); // Call the delete function
            }
        }

        if (event.target.classList.contains("edit-btn")) {
            // Populate form with existing user data for editing
            const user = await getUserById(userId);
            if (user) {
                document.getElementById("name").value = user.name;
                document.getElementById("email").value = user.email;
                document.getElementById("role").value = user.role;
                // You can extend this for other fields if needed
            }
        }
    });

    // Function to get a user by ID for editing
    async function getUserById(id) {
        const userToken = localStorage.getItem('authToken');
        const response = await fetch(`http://192.168.1.7:8080/api/users/${id}`, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${userToken}`,
            },
        });

        if (response.ok) {
            const userData = await response.json();
            return userData; // Return user data for population
        } else {
            console.error('Could not fetch user for editing.');
            alert('Error fetching user data for editing');
        }
    }

    // Handle form submission for adding and editing users
    addUserForm.addEventListener("submit", async (event) => {
        event.preventDefault();

        const name = document.getElementById("name").value;
        const email = document.getElementById("email").value;
        const role = document.getElementById("role").value;
        const userToken = localStorage.getItem('authToken');

        // If editing an existing user
        if (editingUserId) {
            try {
                const response = await fetch(`http://192.168.1.7:8080/api/users/${editingUserId}`, {
                    method: 'PUT',
                    headers: {
                        'Content-Type': 'application/json',
                        'Authorization': `Bearer ${userToken}`,
                    },
                    body: JSON.stringify({ name, email, role }),
                });

                if (!response.ok) {
                    throw new Error('Error updating user: ' + response.statusText);
                }

                alert('User updated successfully!');
                editingUserId = null; // Reset the editing user ID
                addUserForm.reset(); // Reset the form
                fetchUsers(); // Refresh the user list
            } catch (error) {
                console.error('Update error:', error);
                alert('Could not update user. Please try again later.');
            }
        } else {
            // Add a new user (if no editing is happening)
            // Here you may want to implement the logic for adding a new user
        }
    });

    // Function to delete a user
    async function deleteUser(userId) {
        const userToken = localStorage.getItem('authToken');
        try {
            const response = await fetch(`http://192.168.1.7:8080/api/users/${userId}`, {
                method: 'DELETE',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${userToken}`,
                },
            });

            if (!response.ok) {
                throw new Error('Error deleting user: ' + response.statusText);
            }

            fetchUsers();
        } catch (error) {
            console.error('Delete error:', error);
            alert('Could not delete user. Please try again later.');
        }
    }

    // Logout function
    document.getElementById("logout-button").addEventListener("click", () => {
        localStorage.removeItem("authToken"); // Clear the authentication token
        sessionStorage.clear(); // Clear session storage
        window.location.href = "../Login/Login_Role.html"; // Redirect to login page
    });
});
