// selecting count element from html
const counter = document.querySelector(".count");
async function updateCounter() {
    // fetch response
    let response = await fetch(
        "https://dgipwo4zvirfmbxmpdr7r55mta0rmoek.lambda-url.us-west-2.on.aws/"
    );
    //get viewer count and update
    let data = await response.json();
    counter.innerHTML = `Views: ${data}`;
}
updateCounter();