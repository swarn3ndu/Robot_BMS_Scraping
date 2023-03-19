# Robot_BMS_Scraping
A Sample Robot project to scrape Movie Details From Book My Show Website using Selenium

USAGE:
1. Make sure your local machine has Python 3.X
2. Download this repository to a folder on local machine
3. Create a virtual environment in the same forlder using following command 
  3a. Install venv using "py -m pip install --user virtualenv"
  3b. Create virtual env using "py -m venv env". Here 'env' is the name of the virtual environment, you can give any name you wish.
  3c. Activate the vitual envirnmanet using this command ".\env\Scripts\activate"
4. Install all the required packages using command  " pip install -r .\requirements.txt "
5. Once all packages are installed now you can run this project.
6. Use command "python.exe -m robot ." to run this project.
7. The output will be a excel sheet @ <YOUR FOLDER PATH>\actual\output\Movie.xlsx. It also generates JSON files at the same location for further use.
8. Configurations can be changed from the file @ <YOUR FOLDER PATH>\actual\resources.robot


TroubleShooting:

WebDriverException: Message: 'chromedriver' executable needs to be in PATH.
  1. Download chrome driver if you havent.(https://chromedriver.chromium.org/home)
  2. Once downloaded, copy the driver into VENV of your current robot project.
  3. Now run.
