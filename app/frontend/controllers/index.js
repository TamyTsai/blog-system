// Load all the controllers within this directory and all subdirectories. 
// Controller files must be named *_controller.js.

import { Application } from "stimulus" 
import { definitionsFromContext } from "stimulus/webpack-helpers"
// 前兩行與stimulus有關

const application = Application.start()
const context = require.context("controllers", true, /_controller\.js$/) 
// require只會載入一次
// 會去找所有檔案名稱有_controller.js的檔案，把他們載入進來
application.load(definitionsFromContext(context))
