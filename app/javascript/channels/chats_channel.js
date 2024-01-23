import consumer from "./consumer";

document.addEventListener("DOMContentLoaded", () => {
  const chatElement = document.getElementById('chat');
  if (chatElement) {
    const groupId = chatElement.dataset.groupId;

    consumer.subscriptions.create({ channel: "ChatsChannel", group_id: groupId }, {
      received(data) {
        // メッセージを受信したときの処理
        const chatFrame = document.getElementById("chats");
        chatFrame.innerHTML += data;
      }
    });
  }
});