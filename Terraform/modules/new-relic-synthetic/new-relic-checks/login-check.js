// This part is only for local testing


const IS_LOCAL_ENV = typeof $driver === 'undefined';

if (IS_LOCAL_ENV) {
  const $driver = require('selenium-webdriver');

  const $browser = new $driver.Builder().forBrowser('chrome').build();

  $browser.waitForElement = function(locatorOrElement, timeoutMsOpt) {
    return $browser.wait($driver.until.elementLocated(locatorOrElement), timeoutMsOpt || 1000,
        'Timed-out waiting for element to be located using: ' + locatorOrElement);
  };
  $browser.waitForAndFindElement = function(locatorOrElement, timeoutMsOpt) {
    return $browser.waitForElement(locatorOrElement, timeoutMsOpt)
        .then(function(element) {
          return $browser.wait($driver.until.elementIsVisible(element), timeoutMsOpt || 1000,
              'Timed-out waiting for element to be visible using: ' + locatorOrElement)
              .then(function() {
                return element;
              });
        });
  };

  const url = 'https://forms.dev.app.company-solutions.com'; // eslint-disable-line no-unused-vars
  const username = 'app-trainer-dev@nomfa.company.id'; // eslint-disable-line no-unused-vars
  const password = process.env.USER_PASSWORD; // eslint-disable-line no-unused-vars
} else {
  const url = 'https://forms.${env}.app.company-solutions.com'; // eslint-disable-line no-unused-vars
  const username = 'app-trainer-${env}@nomfa.company.id'; // eslint-disable-line no-unused-vars
  const password = $secure.LOGIN_CHECK_ENV_TO_REPLACE_PASSWORD; // eslint-disable-line no-unused-vars
}

// $browser.addHeader('User-Agent', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/102.0.5005.61 Safari/537.36');

console.log(1, 'Open URL: ', url);
$browser.get(url).then(function() {
  return console.log(2, 'Wait for login button'), $browser.waitForAndFindElement($driver.By.className('label__2-psn'), 7500);
}).then(function() {
  return console.log(3, 'Click login button'), $browser.findElement($driver.By.className('label__2-psn')).click();
}).then(function() {
  return console.log(4, 'Wait for username field'), $browser.waitForAndFindElement($driver.By.name('username'), 7500);
}).then(function() {
  return console.log(5, 'Type username'), $browser.findElement($driver.By.name('username')).sendKeys(username);
}).then(function() {
  return console.log(6, 'Wait for submit button'), $browser.waitForAndFindElement($driver.By.className('btn'), 7500);
}).then(function() {
  return console.log(7, 'Click Submit button'), $browser.findElement($driver.By.className('btn')).click();
}).then(function() {
  return console.log(8, 'Wait for password field'), $browser.waitForAndFindElement($driver.By.name('password'), 7500);
}).then(function() {
  return console.log(9, 'Type password'), $browser.findElement($driver.By.name('password')).sendKeys(password);
}).then(function() {
  return console.log(10, 'Wait for submit button'), $browser.waitForAndFindElement($driver.By.className('button button-primary'), 7500);
}).then(function() {
  return console.log(11, 'Click submit'), $browser.findElement($driver.By.className('button button-primary')).click();
}).then(function() {
  return console.log(12, 'Wait for user menu'), $browser.waitForAndFindElement($driver.By.className('rotate180__FLXDl'), 7500);
}).then(function() {
  return console.log(13, 'Click User menu'), $browser.findElement($driver.By.className('rotate180__FLXDl')).click();
}).then(function() {
  return console.log(14, 'Wait for logout menu'), $browser.waitForAndFindElement($driver.By.linkText('Log out'), 7500);
}).then(function() {
  return console.log(15, 'Click "Log out"'), $browser.findElement($driver.By.linkText('Log out')).click();
}).then(function() {
  return console.log(16, 'Close Browser'), $browser.close();
});
