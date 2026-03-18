document.getElementById("submit").addEventListener("click", async () => {
    const question = document.getElementById("user_input").value;
    const responseDiv = document.getElementById("response");

    responseDiv.innerText = "Loading...";

    try {
        const res = await fetch("http://127.0.0.1:8000/query", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ question: question })
        });
        const data = await res.json();
        responseDiv.innerText = data.answer || data.error;
    } catch (err) {
        responseDiv.innerText = "Error connecting to backend.";
    }
});