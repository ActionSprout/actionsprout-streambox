const electron = require('electron')
const app = electron.app
const BrowserWindow = electron.BrowserWindow

const path = require('path')
const fs = require('fs');
const url = require('url')


// Keep a global reference of the window object, if you don't, the window will
// be closed automatically when the JavaScript object is garbage collected.
let mainWindow
if(!process.env.WIDTH)
{
  process.env.WIDTH = "1280";
}

if(!process.env.HEIGHT)
{
  process.env.HEIGHT = "720";
}

if(!process.env.BROADCAST_END)
{
  //TODO(Clark) Set this to something sensible like Four Hours
  process.env.BROADCAST_END = new Date().getTime() + 100;
}

function createWindow () {
  // Create the browser window.
  mainWindow = new BrowserWindow({
    width: 1280, //parseInt(process.env.width),
    height: 720, //parseInt(process.env.height),
    x: 0,
    y: 0,
    frame: false,
    webSecurity: false
    //kiosk: true
  })
  mainWindow.setMenu(null)

  // and load the index.html of the app.
  if(process.env.WEBHOST) {
    mainWindow.loadURL(process.env.WEBHOST)
  }
  else {
    mainWindow.loadURL(url.format({
      pathname: path.join(__dirname, '../static/index.html'),
      protocol: 'file:',
      slashes: true
    }))
  }

  // Open the DevTools.
  // mainWindow.webContents.openDevTools()

  // Emitted when the window is closed.
  mainWindow.on('closed', function () {
    // Dereference the window object, usually you would store windows
    // in an array if your app supports multi windows, this is the time
    // when you should delete the corresponding element.
    mainWindow = null
  })
}

// This method will be called when Electron has finished
// initialization and is ready to create browser windows.
// Some APIs can only be used after this event occurs.
app.on('ready', createWindow)

// Quit when all windows are closed.
app.on('window-all-closed', function () {
  // On OS X it is common for applications and their menu bar
  // to stay active until the user quits explicitly with Cmd + Q
  if (process.platform !== 'darwin') {
    app.quit()
  }
})

app.on('activate', function () {
  // On OS X it's common to re-create a window in the app when the
  // dock icon is clicked and there are no other windows open.
  if (mainWindow === null) {
    createWindow()
  }
})

const _length = parseInt(process.env.BROADCAST_END) - new Date().getTime();
setTimeout(app.quit, _length * 1000);
