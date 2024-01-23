import { Controller } from "@hotwired/stimulus";
import consumer from "../channels/consumer";
import ApplicationController from "./application_controller"

export default class extends Controller {
  connect() {
    let groupId = this.element.dataset.groupId;
    this.sub = this.createActionCableChannel(groupId);

    
  }

  createActionCableChannel(groupId) {
    return consumer.subscriptions.create(
      { channel: "ChatsChannel" + groupId },
      {
        connected() {
          // Called when the subscription is ready for use on the server
          this.perform("get_user_data");
        },

        disconnected() {
          // Called when the subscription has been terminated by the server
        },

        received(data) {
          // Called when there's incoming data on the websocket for this channel
          const newMessageHtml = `
          <div class="chat">
          <div class="chat-user">${data.user.name}</div> 
          <div class="chat-message">
           ${data.body}
          </div>
          <div class="chat-createdat">
           ${data.createdAt} 
         </div>
        </div>
          `;

          // メッセージ一覧に追加
          const messageList = document.getElementById("chats");
          messageList.innerHTML += newMessageHtml;
        },
      }
    );
  }
}
