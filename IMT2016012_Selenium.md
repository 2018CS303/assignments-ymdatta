1. Install selenium using pip
	```
    pip install -U selenium
    ```
    
    **Note:** If your system has both ```python2``` and ```python3```, the above command install ```selenium```
    for ```python2``` version. If you want to do the same for ```python3```, use ```pip3```.
    
2. Downlod Firefoxdriver for selenium from ```https://github.com/mozilla/geckodriver/releases```.

	* Untar the downloaded tar file:
	   
        ```Ex: tar -xzvf geckodriver-v0.23.0-linux64.tar.gz```
        
    * Now, we need to add ```geckodriver``` to ```$PATH```, or we need to place it in a folder recognized by ```$PATH```.
    	* To add it to the path do:
    	     ```export PATH=$PATH:~/path/to/geckodriver```
        * To place it in a folder recognized by ```$PATH```.
          
          (Here we use ```/usr/local/bin``` for example)
          
          ```sudo cp ~/path/to/geckodriver /usr/local/bin/```
          
    **Note:** This driver should be executable. To make it executable
    
    ```chmod +x /path/to/geckodriver```
          
3. We can use this driver to run all the test cases on the broswer. The following code demonstrates a simple usage:

```
from selenium import webdriver

driver  = webdriver.Firefox()

driver.get('https://www.iiitb.ac.in/')

# small-test - 1,
# if 'Internationale' is there
# in driver.title: it returns nothing, if it
# isn't it gives AssertionError

assert 'Internationale' in driver.title

# small-test - 2
assert 'Bangalore' in driver.title

driver.quit()

```

The above code gives only one ```AssertionError``` because ```Internationale``` is not present in 

```driver.title(=International Institute of Information Technology, Bangalore)``` 
and ```Bangalore``` is present.

4. If we observe, the above code displays the broswer while executing, if we don't want that and we still want the code related to browser(i.e tests) to occur in the background, we can modify the above code to do this. We add a `--headless` option to the drive while defining it. The below code gives the same output as the previous code, but it doesn't open browser in the process.

```
from selenium import webdriver

options = webdriver.FirefoxOptions()
# adding'headless' option.
options.add_argument('--headless')
driver  = webdriver.Firefox(options = options)

driver.get('https://www.iiitb.ac.in/')

# small-test - 1,
# if 'Internationale' is there
# in driver.title: it returns nothing, if it
# isn't it gives AssertionError

assert 'Internationale' in driver.title

# small-test - 2
assert 'Bangalore' in driver.title

driver.quit()
```
