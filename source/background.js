const onAlarmData = function () {
    fetch("https://raw.githubusercontent.com/noesya/ecogestes-mirror/main/file/ecowatt.json").then(function (res) {
        return res.json();
    }).then(function (signals) {
        chrome.storage.local.set({ signals });
    })
}

chrome.runtime.onInstalled.addListener(function () {
    chrome.alarms.create("ecogestes-data", { when: Date.now(), periodInMinutes: 60 });
});

chrome.alarms.onAlarm.addListener(function (alarm) {
    if (alarm.name === "ecogestes-data") {
        onAlarmData();
    }
})

chrome.notifications.onClicked.addListener(function (notificationId) {
    if (notificationId === "ECOGESTES_DEBUG_NOTIF") {
        chrome.notifications.clear("ECOGESTES_DEBUG_NOTIF");
        chrome.tabs.create({ url: "index.html" });
    }
});

chrome.runtime.onMessage.addListener(data => {
    if (data.type === 'notification') {
        chrome.notifications.create('ECOGESTES_DEBUG_NOTIF', {
            title: 'Écogestes - Débogage',
            message: 'Ceci est une notification de débogage.',
            iconUrl: '/icon.png',
            type: 'basic'
        });
    }
});