import { Controller } from "@hotwired/stimulus"

export default class ApplicationController extends Controller {
  // 共通のメソッドや値を定義
  static values = { userId: Number }
}