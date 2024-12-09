
document.getElementById('login-form').addEventListener('submit', async function (e) {
    e.preventDefault();

    const email = document.getElementById('username').value.trim();
    const password = document.getElementById('password').value.trim();

    if (!email || !password) {
        return alert('Please enter both email and password!');
    }

    try {
        const response = await fetch('http://192.168.1.7:8080/api/login', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ email, password }),
        });

        // Handling response based on status
        if (!response.ok) {
            const errorData = await response.json();
            return alert(errorData.message || 'Đăng nhập thất bại!'); 
        }

        const data = await response.json();
        localStorage.setItem('authToken', data.token);
        console.log('No co chay toi day na'+ data.user.role);

        if (data.user.role == 'admin') {
            window.location.href = 'http://127.0.0.1:5500/web/role/Admin/Admin_Dash.html';
        } else {
            alert('Không đủ quyền truy cập!');
        }
    } catch (error) {
        console.error('Error during login:', error);
        alert('An error occurred. Please try again later.');
    }
});
