# ***** CI Forms test, D.C.Palumbo 29 May 2018 **************************************
#--------------------- Version 1.1 -------------------------------------------------*
# ---------- Last code update: 6 June 2018	----------------------------------------*
# Merged ci and MT4 code bases.                                                     *
# added code (case statements) to handle changing ID's in environments.             *
# added code to handle different environments.                                      *
# added error snap-shot for the following test pages:                               *
# Title															                    *
# Confirmation													                    *
# Submit                                                                            *
# added countrys_list.config file                                                   *
# Simple flat file format example below:                                            *
# ruby demo-test-ci-mt4.rb https://qa.cityindex.co.uk/demo-mt4-account/?redir=0	qa  *
# ~~~~~~~~~~~~~~~											                        *
# Algeria 													                        *			
# United Kingdom 												                    *	
# next country													                    *
# ~~~~~~~~~~~~~~~											                        *
# Ruby watir documentation.										                    *
# https://github.com/watir/watir_meta/wiki/Page-Elements		                    *
# ***********************************************************************************
# to do list:                                                   				    *
# 1. Add Test counts, Total, Pass & Fail                                            *
# ***********************************************************************************

require 'rspec'
require 'rubygems'
require 'page-object'        
require 'watir'              # watir selenium package.
require 'rspec/expectations' # expects not working, setup issue?

# ************** Shared Test Code ***************************************************
class DemoTestCi	
  include PageObject	# a page object
  $site_url = ARGV[0]
  $env = ARGV[1]
  $brand = ARGV[2]
  $test_count = 0
  $test_failed_count = 0
  $test_pass_count = 0
  
    case $env
	  when "qa"
	    puts ""
	    puts "qa env is valid ... beginning the test."
	    puts ""
	  when "uat"
	    puts ""
	    puts "uat env is valid ... beginning the test."
	    puts ""
	  when "preview"
        puts ""
	    puts "preview env is valid ... beginning the test."
	    puts ""
      when "live"
       	puts ""
	    puts "live env is valid ... beginning the test."
	    puts "" 
	  else 
	    puts ""
	    puts "ARV1 must be lower case!"
	    puts "Validate env are qa, uat, preview & live"
	    puts ""
	    exit
	 end
  # $site_url = "https://qa.cityindex.co.uk/demo-mt4-account/?redir=0" 
end  

def setup_browser_firefox 
  $browser = Watir::Browser.new :firefox	# open a browser default is chrome
    rescue
	  puts ""
	  puts "Unable to opened / setup browser."
	  puts ""
	  tear_down
	  	else
		  $results.puts "<br>Successfully opened / setup Firefox browser." 
end

def setup_browser_chrome 
  $browser = Watir::Browser.new	# open a browser default is chrome
  $browser.send_keys [:control, '-']  # chrome browser - Zoom in or out of a page, "-" will zoom out and "+" will zoom in
    rescue
	  $results.puts "<br>Unable to opened / setup browser."
	  tear_down
	  	else
		  $results.puts "<br>Successfully opened / setup Chrome browser." 
end

def site_connect_ci
  $browser.goto $site_url
  sleep 2
   	rescue
	  $results.puts "<br>Unable to Connect to the Site Host = " + $site_url 
		else
		  $results.puts "<br>Successfully Connected to host = " + $site_url 
end

def browser_quit  
  $browser.quit
	rescue
	  $results.puts "<br>Unable to quit browser!"
		else
		  $results.puts "<br>Successfully quit browser!"
end

def create_summary_logfile
  get_unique_number
  case $brand 
  when "ci"
    x = "/inetpub/wwwroot/AutoTestResults/CI-Forms/Summary/"
    y = "CIFormsSummary" + $unique_number + ".htm"
    log_file_create1 = File.new("#{x}#{y}", "w")
    $summary_results = File.new("#{x}#{y}", "a")
    # $summary_results = File.new("/inetpub/wwwroot/AutoTestResults/CI-Forms/demo_form_summary_results.log", "w")
  when "mt4"
    x3 = "/inetpub/wwwroot/AutoTestResults/CI-Forms/MT4-Forms/"
    y3 = "MT4FormsSummary" + $unique_number + ".htm"
    log_file_create1 = File.new("#{x3}#{y3}", "w")
    $summary_results = File.new("#{x3}#{y3}", "a")
  end
     rescue 
	  puts "Not Able to Create Summary Log File!"
	  exit
	    else
		  $results.puts "<br>Summary Log File Created Successfully!"
end
	
def create_detailed_logfile
  get_unique_number
  case $brand 
	when "ci"
		detailed_path = "/inetpub/wwwroot/AutoTestResults/CI-Forms/Detailed/"
		log_name = "CIFormsDetailed" + $unique_number + ".htm"
		log_file_create2 = File.new("#{detailed_path}#{log_name}", "w")
		$results = File.new("#{detailed_path}#{log_name}", "a")
	when "mt4"
		detailed_path = "/inetpub/wwwroot/AutoTestResults/CI-Forms/MT4-Forms/"
		log_name = "MT4FormsDetailed" + $unique_number + ".htm"
		log_file_create2 = File.new("#{detailed_path}#{log_name}", "w")
		$results = File.new("#{detailed}#{log_name}", "a")
	end	 
	  rescue 
	    puts "Not Able to Create Detailed Log File!"
	    exit
	      else
		    $results.puts "<br>Detailed Log File Created Successfully!"
end

def summary_logfile_close
  $summary_results.close
    rescue
	  $results.puts "<br>Unable to Close summary log file!</br>"
		else
		  puts "Successfully closed summary log file!"
end

def detailed_logfile_close
  $results.close
  	rescue
	  $results.puts "<br>Unable to Close log file!"
		else
		  puts "Successfully closed detailed log file!"
end

def error_title_demo_signup_page
  $results.puts "<br>Test Failed - Unable to validate demo sign-up page's title."
  $summary_results.puts "<br>Test Failed - Unable to validate demo sign-up page's title."
  get_unique_number
  $browser.screenshot.save "Demo_Signup_Page_Error" + $unique_number + ".png"
     rescue
	  $results.puts "<br>Title Error trapped Failed!"
	    else
	      $results.puts "<br>Title Error trapped!"
end

def error_title_confirm_page
  $results.puts "<br>Test Failed - Unable to validate Confirmation Page's Title."
  $summary_results.puts "<br>Test Failed - Unable to validate Confirmation page's title."
  get_unique_number             
  $browser.screenshot.save "Confirm_Page_Error" + $unique_number + ".png"
    rescue
	  $results.puts "<br>Title Error trapped Failed!"
	    else
	      $results.puts "<br>Title Error trapped!"
end

def error_title_submit_page
  $results.puts "<br>Test Failed - Unable to validate Submit Page's Title.<br/r>"
  $summary_results.puts "<br>Test Failed - Unable to validate Submit page's title."
  # get_unique_number             
  # $browser.screenshot.save "Submit_Page_Error" + $unique_number + ".png"
    rescue
	  $results.puts "<br>Title Error trapped Failed!"
	    else
	      $results.puts "<br>Title Error Trapped!"
end

def get_unique_number
  time = Time.now
  tyear = time.year.to_s 
  tmonth = time.month.to_s
  tday = time.day.to_s
  thour = time.hour.to_s
  tmin = time.min.to_s
  tsec = time.sec.to_s 
  $unique_number = tyear+tmonth+tday+thour+tmin+tsec
     rescue
	    puts "Get_Unique Number Failed."
  		   else
		     puts "Successfully Created a Unique."
end

def get_server_name
  server_name = $browser.element(:xpath,"//*[contains(@id, 'DebugInfo')]").value
  rescue
    $results.puts "<br>Unable to find server name!"
       else	
	     $results.puts "<br>Server Name = " + server_name 
		 $summary_results.puts "<br>Server = " + server_name 
end

def tear_down
  browser_quit
  summary_logfile_close   # outputs to console.
  detailed_logfile_close  # outputs to console. 
end

def setup_firefox
  create_detailed_logfile
  create_summary_logfile
  setup_browser_firefox
end

def setup_chrome
  create_detailed_logfile
  create_summary_logfile
  setup_browser_chrome
end

def get_country_config
  # Initialize the country test string Array. # $countrys = ["Algeria", "United Kingdom"]
  $countrys = [] # Array.new empty
  $countrys = File.open("country_list.config") or die "Unable to open country configuration file..."
end

def setup_negative_test
  $summary_results.puts "<br>Starting Negative Demo Form Test."
  $results.puts "<br>Starting Negative Demo Form Test."
end

def accept_cookie_policy
  #sleep 1
  if $browser.element(:xpath,"//*[contains(@class, 'cta-btn blue alert__close')]").exists? == true
         $browser.element(:xpath,"//*[contains(@class, 'cta-btn blue alert__close')]").click
		    else
			    $results.puts "<br>Cookie opt in button Not Found"
  end
    rescue
	  $results.puts "<br>Error: cookie opt in button method!"
		else
		  $results.puts "<br>Successfully completed cookie opt in method!"
end 

# ******************************** MT4 code base *******************************************

def mt_populate_form_first_name		# tests first name test field
  fname = "dave"
  case $env  # env = qa
  when "qa" 
    $browser.element(:id => '634c982c-4eca-448b-9331-c9251dc84311').send_keys(fname)
  when "preview" 
    $browser.element(:id => '8e297477-cd0e-4a3f-a688-28b36c2f3ce5').send_keys(fname)
  when "uat"
    $browser.element(:id => '634c982c-4eca-448b-9331-c9251dc84311').send_keys(fname)
  when "live"
    $browser.element(:id => '8e297477-cd0e-4a3f-a688-28b36c2f3ce5').send_keys(fname)   
  else
    $results.puts "<br>Error First Name ID has changed!" 
  end
  #sleep 1  
      rescue
	    $results.puts "<br>Unable to find first name element!"
		  else
		    $results.puts "<br>Successfully found first name!"
end
 
def mt_populate_form_last_name		# tests last name text field
  case $env  # env = qa
  when "qa" 
    $browser.element(:id => 'fbb6ea94-f0de-41ab-b3ea-6323fa9d54af').send_keys("testtest")
  when "preview" 
    $browser.element(:id => '0a84bf4d-9c43-4382-93f7-07914c28dafa').send_keys("testtest")
  when "uat"
    $browser.element(:id => 'fbb6ea94-f0de-41ab-b3ea-6323fa9d54af').send_keys("testtest")
  when "live"
    $browser.element(:id => '0a84bf4d-9c43-4382-93f7-07914c28dafa').send_keys("testtest")
  else
    $results.puts "Error Last Name ID has changed!" 
  end
  	rescue
	  $results.puts "<br>Unable to find last name element!"
	     else
		  $results.puts "<br>Successfully found last name!"
end

def mt_populate_form_email			# tests email address text field.
  part1 = "gaincap"
  part2 = "@mailinator.com"
  get_unique_number
  email = part1 + $unique_number + part2	# builds email address with unique number.
  case $env  # env = qa
  when "qa" 
    $browser.element(:id => 'abfca888-c0f9-434a-98bd-fe02ab992619').send_keys(email)
  when "preview" 
    $browser.element(:id => '4cb056e7-a157-4f16-84eb-96338319526f').send_keys(email)
  when "uat"
    $browser.element(:id => 'abfca888-c0f9-434a-98bd-fe02ab992619').send_keys(email)
  when "live"
    $browser.element(:id => '4cb056e7-a157-4f16-84eb-96338319526f').send_keys(email)
  else
    $results.puts "<br>Error email address ID has changed!" 
  end
   	rescue
	  $results.puts "<br>Unable to find Email element!"
	  	else
		  $results.puts "<br>Successfully found Email element!"
end

def mt_populate_form_phone_number
  # phone number test field - hard coded must change with country?
  case $env  # env = qa
  when "qa" 
    $browser.element(:id => '5df983dd-bb2b-4873-8a7d-dea0b995a5ec').send_keys("5556669898")
  when "preview" 
    $browser.element(:id => 'a72a2872-e352-4181-b68a-19582915c30f').send_keys("5556669898")
  when "uat"
    $browser.element(:id => '5df983dd-bb2b-4873-8a7d-dea0b995a5ec').send_keys("5556669898")
  when "live"
    $browser.element(:id => 'a72a2872-e352-4181-b68a-19582915c30f').send_keys("5556669898")
  else
    $results.puts "<br>Error Phone number ID has changed!" 
  end
   	rescue
	  $results.puts "<br>Unable to find phone number element!"
	  	else
		  $results.puts "<br>Successfully found phone number element!"
end
	
def mt_set_country_dropdown	
  sleep 2
  case $env  # env = qa
  when "qa" 
    # $browser.element.input(:xpath,"//*[contains(@id, '6b0f5f44_4ed6_495b_b4d7_d3dacc2df2f2')]").click # needed for chrome only!
    $browser.element(:xpath,"//*[contains(@id, '6f433af6_4f7a_481a_a973_047c7047ce67')]").click
    # $browser.element(:xpath,"//select[contains(@name, 'Country')]").click
    $browser.send_keys ($country)
  when "preview" 
    # $browser.element.input(:xpath,"//*[contains(@id, 'a1f50aea_610b_4b0a_8ace_574764a739c7')]").click # needed for chrome only!
    $browser.element(:xpath,"//*[contains(@id, '')]").click
    # $browser.element(:xpath,"//select[contains(@name, 'Country')]").click
    $browser.send_keys ($country)
  when "uat"
    # $browser.element.input(:xpath,"//*[contains(@id, '6b0f5f44_4ed6_495b_b4d7_d3dacc2df2f2')]").click # needed for chrome only!
    $browser.element(:xpath,"//*[contains(@id, '6f433af6_4f7a_481a_a973_047c7047ce67')]").click
    # $browser.element(:xpath,"//select[contains(@name, 'Country')]").click
    $browser.send_keys ($country)
  when "live"
    # $browser.element.input(:xpath,"//*[contains(@id, 'a1f50aea_610b_4b0a_8ace_574764a739c7')]").click # needed for chrome only!
    # $browser.element(:xpath,"//*[contains(@id, 'a1f50aea_610b_4b0a_8ace_574764a739c7')]").click
	sleep 1
	$browser.element(:xpath,"//*[contains(@id, 'a1f50aea_610b_4b0a_8ace_574764a739c7')]").click
	sleep 1
    # $browser.element(:xpath,"//select[contains(@name, 'Country')]").click
    $browser.send_keys ($country)
	sleep 1
  else
    $results.puts "<br>Error Phone number ID has changed!" 
  end
  	rescue
	  $results.puts "<br>Unable to set country drop-down box!"
	  # get_unique_number 
	  # $browser.screenshot.save "Submit_Page_dropdowm_Error" + $unique_number + ".png"
	  	else
		  $results.puts "<br>Successfully set country drop-down box!"
end
					
def mt_demo_form_submit 
  #sleep 1
  # $browser.element.button(:xpath,"//*[contains(@class, 'form-submit form-buttonSubmit cta-btn blue')]").click
  $browser.send_keys :enter  
    sleep 3
	  rescue
	    $results.puts "<br>Form Submit Failed!"
	    #get_unique_number
	    #$browser.screenshot.save "Submit_Page_Error" + $unique_number + ".png"
		  else
		    $results.puts "<br>Successfully clicked submit button!"
end

def mt_validate_confirm_page
  sleep 3
  title_from_page = $browser.title
  $results.puts "<br>Title from Confirmation page = " + title_from_page 
  expected_title = "Your MT4 Demo Account is now Active | City Index"
  #expected_title = "Advantage Web demo account creation error"
  $results.puts "<br>Expected Confirm title = " + expected_title 
      if title_from_page == expected_title
      #expect($browser.title).to include("Your Advantage Web Demo Account is now Active | City Index")
	  $results.puts "<br>Pass - Demo form sign-up country = " + $country 
	  $summary_results.puts "<br>Pass - Demo form sign-up country = " + $country 
	  $test_pass_count = $test_pass_count + 1
        else 
		  $results.puts "<br>Title values do not match!"
		  $test_failed_count = $test_failed_count + 1
		  error_title_confirm_page
      end
         rescue
           $results.puts "<br>Error Validate Confirm Page Code."
		     else	
               $results.puts "<br>Successfully Validate_confirm_page."
end

def mt_negative_validate_confirm_page
  #sleep 2
  title_from_page = $browser.title
  $results.puts "<br>title from Confirmation page = " + title_from_page
  expected_title = "Your MT4 Demo Account is now Active | City Index"
  #expected_title = "Advantage Web demo account creation error"
  $results.puts "<br>Expected Confirm title = " + expected_title 
      if title_from_page == expected_title
      #expect($browser.title).to include("Your Advantage Web Demo Account is now Active | City Index")
	  $results.puts "<br>Pass - Demo form sign-up country = " + $country 
	  $summary_results.puts "<br>Pass - Demo form sign-up country = " + $country 
	  $test_failed_count = $test_failed_count + 1
        else 
		  $results.puts "<br>Title values do not match!"
		  $test_pass_count = $test_pass_count + 1
	  end
         rescue
           $results.puts "<br>Error validate_confirm_page code."
		     else	
               $results.puts "<br>Successfully Validate Confirm Page"
end

def mt_validate_title_demo_signup
  #sleep 1
  title_from_page = $browser.title
  expected_title = "Open a Demo MT4 Account | Begin Trading Online | City Index UK" 
  #expected_title = "Trade Error"
  $results.puts "<br>Title Expected = " + expected_title 
  $results.puts "<br>Title on page = " + title_from_page 
  if title_from_page == expected_title
     #expect($browser.title).to include("Trading Account | Open Demo Trading Account | City Index UK")
	 $results.puts "<br>Validated Demo sign-up form's title"
	 else  
	   $results.puts "<br>Title values do not match!"
	   error_title_demo_signup_page
  end   
    rescue
      $results.puts "<br>Error validating Demo form's title."
	    else
          $results.puts "<br>Successfully validated demo form's title."
end

def mt4_form_demo_test
  # This is a positive test for the MT4 CI Demo form
  site_connect_ci
  accept_cookie_policy
  get_server_name
  mt_validate_title_demo_signup
  mt_populate_form_first_name
  mt_populate_form_last_name
  mt_populate_form_email
  mt_populate_form_phone_number
  mt_set_country_dropdown
  mt_demo_form_submit
  mt_validate_confirm_page
end

def negative_mt4_form_demo_test
  # This is a negative test for the CI Demo form
  site_connect_ci
  accept_cookie_policy
  get_server_name
end

# ****************Invalid Data MT4 Negative Tests *********************************

def mt_populate_form_first_name_with_numbers
  #sleep 1
  fname = "dave897"
  case $env  # env = qa
  when "qa" 
    $browser.element(:id => '634c982c-4eca-448b-9331-c9251dc84311').send_keys(fname)
  when "preview" 
    $browser.element(:id => '8e297477-cd0e-4a3f-a688-28b36c2f3ce5').send_keys(fname)
  when "uat"
    $browser.element(:id => '634c982c-4eca-448b-9331-c9251dc84311').send_keys(fname)
  when "live"
    $browser.element(:id => '8e297477-cd0e-4a3f-a688-28b36c2f3ce5').send_keys(fname)   
  else
    $results.puts "<br>Error First Name ID has changed!" 
  end
  #sleep 1  
      rescue
	    $results.puts "<br>Unable to find first name element!"
		  else
		    $results.puts "<br>Successfully found first name!"
end

def mt_populate_form_last_name_with_numbers
  case $env  # env = qa
  when "qa" 
    $browser.element(:id => 'fbb6ea94-f0de-41ab-b3ea-6323fa9d54af').send_keys("test1234")
  when "preview" 
    $browser.element(:id => '0a84bf4d-9c43-4382-93f7-07914c28dafa').send_keys("test1234")
  when "uat"
    $browser.element(:id => 'fbb6ea94-f0de-41ab-b3ea-6323fa9d54af').send_keys("test1234")
  when "live"
    $browser.element(:id => '0a84bf4d-9c43-4382-93f7-07914c28dafa').send_keys("test1234")
  else
    $results.puts "<br>Error Last Name ID has changed!" 
  end
  	rescue
	  $results.puts "<br>Unable to find last name element!"
	    else
		  $results.puts "<br>Successfully found last name!"
end

def mt_populate_form_email_invalid_format
part1 = "gaincap"
  part2 = "mailinator.com" # Missing @
  get_unique_number
  email = part1 + $unique_number + part2		# builds email address with unique number.
  case $env  # env = qa
  when "qa" 
    $browser.element(:id => 'abfca888-c0f9-434a-98bd-fe02ab992619').send_keys(email)
  when "preview" 
    $browser.element(:id => '4cb056e7-a157-4f16-84eb-96338319526f').send_keys(email)
  when "uat"
    $browser.element(:id => 'abfca888-c0f9-434a-98bd-fe02ab992619').send_keys(email)
  when "live"
    $browser.element(:id => '4cb056e7-a157-4f16-84eb-96338319526f').send_keys(email)
  else
    $results.puts "<br>Error email address is invalid has changed!" 
  end
   	rescue
	  $results.puts "<br>Unable to find email element!"
		else
		  $results.puts "<br>Successfully found email element!"
end

def mt_populate_form_phone_number_invalid_format
# phone number test field - hard coded must change with country.
  case $env  # env = qa
  when "qa" 
    $browser.element(:id => '5df983dd-bb2b-4873-8a7d-dea0b995a5ec').send_keys("abc6669898")
  when "preview" 
    $browser.element(:id => 'a72a2872-e352-4181-b68a-19582915c30f').send_keys("abc6669898")
  when "uat"
    $browser.element(:id => '5df983dd-bb2b-4873-8a7d-dea0b995a5ec').send_keys("abc6669898")
  when "live"
    $browser.element(:id => 'a72a2872-e352-4181-b68a-19582915c30f').send_keys("abd6669898")
  else
    $results.puts "<br>Error Phone number is invalid has changed!" 
  end
   	rescue
	  $results.puts "<br>Unable to find phone number element!"
		else
		  $results.puts "<br>Successfully found phone number element!"
end

def mt_populate_form_first_name_51_char			# tests first name test field
  fname = "supercalfrdlisticsupercalfrdlisticsupercalfrdlistic"
  case $env  # env = qa
  when "qa" 
    $browser.element(:id => '634c982c-4eca-448b-9331-c9251dc84311').send_keys(fname)
  when "preview" 
    $browser.element(:id => '8e297477-cd0e-4a3f-a688-28b36c2f3ce5').send_keys(fname)
  when "uat"
    $browser.element(:id => '634c982c-4eca-448b-9331-c9251dc84311').send_keys(fname)
  when "live"
    $browser.element(:id => '8e297477-cd0e-4a3f-a688-28b36c2f3ce5').send_keys(fname)   
  else
    $results.puts "<br>Error First Name ID has changed!" 
  end
  #sleep 1  
      rescue
	    $results.puts "<br>Unable to find first name element!"
		  else
		    $results.puts "<br>Successfully found first name!"
end

def mt_populate_form_last_name_51_char		
  lname = "supercalfrdlisticsupercalfrdlisticsupercalfrdlistic"
  case $env  # env = qa
  when "qa" 
    $browser.element(:id => 'fbb6ea94-f0de-41ab-b3ea-6323fa9d54af').send_keys(lname)
  when "preview" 
    $browser.element(:id => '0a84bf4d-9c43-4382-93f7-07914c28dafa').send_keys(lname)
  when "uat"
    $browser.element(:id => 'fbb6ea94-f0de-41ab-b3ea-6323fa9d54af').send_keys(lname)
  when "live"
    $browser.element(:id => '0a84bf4d-9c43-4382-93f7-07914c28dafa').send_keys(lname)
  else
    $results.puts "<br>Error Last Name ID has changed!" 
  end
    rescue
	  $results.puts "<br>Unable to find last name element!"
	    else
		  $results.puts "<br>Successfully found last name!"
end

def mt_populate_form_first_name_one_char		# tests first name test field
  fname = "s"
  case $env  # env = qa
  when "qa" 
    $browser.element(:id => '634c982c-4eca-448b-9331-c9251dc84311').send_keys(fname)
  when "preview" 
    $browser.element(:id => '8e297477-cd0e-4a3f-a688-28b36c2f3ce5').send_keys(fname)
  when "uat"
    $browser.element(:id => '634c982c-4eca-448b-9331-c9251dc84311').send_keys(fname)
  when "live"
    $browser.element(:id => '8e297477-cd0e-4a3f-a688-28b36c2f3ce5').send_keys(fname)   
  else
    $results.puts "<br>Error First Name ID has changed!" 
  end
  #sleep 1  
      rescue
	    $results.puts "<br>Unable to find first name element!"
		  else
		    $results.puts "<br>Successfully found first name!"
end

def mt_populate_form_last_name_one_char		
  lname = "s"
  case $env  # env = qa
  when "qa" 
    $browser.element(:id => 'fbb6ea94-f0de-41ab-b3ea-6323fa9d54af').send_keys(lname)
  when "preview" 
    $browser.element(:id => '0a84bf4d-9c43-4382-93f7-07914c28dafa').send_keys(lname)
  when "uat"
    $browser.element(:id => 'fbb6ea94-f0de-41ab-b3ea-6323fa9d54af').send_keys(lname)
  when "live"
    $browser.element(:id => '0a84bf4d-9c43-4382-93f7-07914c28dafa').send_keys(lname)
  else
    $results.puts "<br>Error Last Name ID has changed!" 
  end
    rescue
	  $results.puts "<br>Unable to find last name element!"
	    else
		  $results.puts "<br>Successfully found last name!"
end

# ****************Invalid Data CI Negative Tests *********************************

def ci_populate_form_first_name_with_numbers		
  #sleep 1
  fname = "dave123"
  case $env  # env = qa
  when "qa" 
    $browser.element(:id => '231fef7f-c134-4bb5-8331-35598004d68e').send_keys(fname)
  when "preview" 
    $browser.element(:id => '01a12e2b-38a1-4207-ad33-1f2ac450c44e').send_keys(fname)
  when "uat"
    $browser.element(:id => '231fef7f-c134-4bb5-8331-35598004d68e').send_keys(fname)
  when "live"
    $browser.element(:id => '01a12e2b-38a1-4207-ad33-1f2ac450c44e').send_keys(fname)   
  else
    $results.puts "<br>Error First Name ID has changed!" 
  end
    rescue
	  $results.puts "<br>Unable to find first name element!"
		else
		  $results.puts "<br>Successfully found first name!"
end

def ci_populate_form_last_name_with_numbers		
  lname = "test1234"
  case $env  # env = qa
  when "qa" 
    $browser.element(:id => 'b5589173-6cb3-4251-bcd7-66793b3a023d').send_keys(lname)
  when "preview" 
    $browser.element(:id => '6fb0f1f5-7c89-4b74-a3a1-d0d5cda629bb').send_keys(lname)
  when "uat"
    $browser.element(:id => 'b5589173-6cb3-4251-bcd7-66793b3a023d').send_keys(lname)
  when "live"
    $browser.element(:id => '6fb0f1f5-7c89-4b74-a3a1-d0d5cda629bb').send_keys(lname)
  else
    $results.puts "<br>Error Last Name ID has changed!" 
  end
  	rescue
	  $results.puts "<br>Unable to find last name element!"
	    else
		  $results.puts "<br>Successfully found last name!"
end

def ci_populate_form_email_invalid_format			
  part1 = "gaincap"
  part2 = "mailinator.com"                      # Missing @
  get_unique_number
  email = part1 + $unique_number + part2		# builds email address with unique number.
  case $env  # env = qa
  when "qa" 
    $browser.element(:id => 'cb88606c-c301-4722-98cc-f19a2e78162b').send_keys(email)
  when "preview" 
    $browser.element(:id => 'afbc255a-79fb-4ae2-b488-b86ede10224e').send_keys(email)
  when "uat"
    $browser.element(:id => 'cb88606c-c301-4722-98cc-f19a2e78162b').send_keys(email)
  when "live"
    $browser.element(:id => 'afbc255a-79fb-4ae2-b488-b86ede10224e').send_keys(email)
  else
    $results.puts "<br>Error email address ID has changed!" 
  end
  	rescue
	  $results.puts "<br>Unable to find email element!"
		else
		  $results.puts "<br>Successfully found email element!"
end

def ci_populate_form_phone_number_invalid_format
  # phone number test field - hard coded must change with country.
  case $env  # env = qa
  when "qa" 
    $browser.element(:id => '954fb4dc-9aa6-4ee9-a23f-a6a932fc68d8').send_keys("abc6669898")
  when "preview" 
    $browser.element(:id => '4b0e2f36-9677-410c-9c80-5a6d1b41839b').send_keys("abc6669898")
  when "uat"
    $browser.element(:id => '954fb4dc-9aa6-4ee9-a23f-a6a932fc68d8').send_keys("abc6669898")
  when "live"
    $browser.element(:id => '4b0e2f36-9677-410c-9c80-5a6d1b41839b').send_keys("abc6669898")
  else
    $results.puts "<br>Error Phone number ID has changed!" 
  end
  	rescue
	  $results.puts "<br>Unable to find phone number element!"
		else
		  $results.puts "<br>Successfully found phone number element!"
end

def ci_populate_form_first_name_51_char		
  #sleep 1
  fname = "supercalfrdlisticsupercalfrdlisticsupercalfrdlistic"
  case $env  # env = qa
  when "qa" 
    $browser.element(:id => '231fef7f-c134-4bb5-8331-35598004d68e').send_keys(fname)
  when "preview" 
    $browser.element(:id => '01a12e2b-38a1-4207-ad33-1f2ac450c44e').send_keys(fname)
  when "uat"
    $browser.element(:id => '231fef7f-c134-4bb5-8331-35598004d68e').send_keys(fname)
  when "live"
    $browser.element(:id => '01a12e2b-38a1-4207-ad33-1f2ac450c44e').send_keys(fname)   
  else
    $results.puts "<br>Error First Name ID has changed!" 
  end
    rescue
	  $results.puts "<br>Unable to find first name element!"
		else
		  $results.puts "<br>Successfully found first name!"
end

def ci_populate_form_last_name_51_char		
  lname = "supercalfrdlisticsupercalfrdlisticsupercalfrdlistic"
  case $env  # env = qa
  when "qa" 
    $browser.element(:id => 'b5589173-6cb3-4251-bcd7-66793b3a023d').send_keys(lname)
  when "preview" 
    $browser.element(:id => '6fb0f1f5-7c89-4b74-a3a1-d0d5cda629bb').send_keys(lname)
  when "uat"
    $browser.element(:id => 'b5589173-6cb3-4251-bcd7-66793b3a023d').send_keys(lname)
  when "live"
    $browser.element(:id => '6fb0f1f5-7c89-4b74-a3a1-d0d5cda629bb').send_keys(lname)
  else
    $results.puts "<br>Error Last Name ID has changed!" 
  end
  	rescue
	  $results.puts "<br>Unable to find last name element!"
	    else
		  $results.puts "<br>Successfully found last name!"
end

def ci_populate_form_first_name_one_char		
  #sleep 1
  fname = "s"
  case $env  # env = qa
  when "qa" 
    $browser.element(:id => '231fef7f-c134-4bb5-8331-35598004d68e').send_keys(fname)
  when "preview" 
    $browser.element(:id => '01a12e2b-38a1-4207-ad33-1f2ac450c44e').send_keys(fname)
  when "uat"
    $browser.element(:id => '231fef7f-c134-4bb5-8331-35598004d68e').send_keys(fname)
  when "live"
    $browser.element(:id => '01a12e2b-38a1-4207-ad33-1f2ac450c44e').send_keys(fname)   
  else
    $results.puts "<br>Error First Name ID has changed!" 
  end
    rescue
	  $results.puts "<br>Unable to find first name element!"
		else
		  $results.puts "<br>Successfully found first name!"
end

def ci_populate_form_last_name_one_char		
  lname = "s"
  case $env  # env = qa
  when "qa" 
    $browser.element(:id => 'b5589173-6cb3-4251-bcd7-66793b3a023d').send_keys(lname)
  when "preview" 
    $browser.element(:id => '6fb0f1f5-7c89-4b74-a3a1-d0d5cda629bb').send_keys(lname)
  when "uat"
    $browser.element(:id => 'b5589173-6cb3-4251-bcd7-66793b3a023d').send_keys(lname)
  when "live"
    $browser.element(:id => '6fb0f1f5-7c89-4b74-a3a1-d0d5cda629bb').send_keys(lname)
  else
    $results.puts "<br>Error Last Name ID has changed!<br>" 
  end
  	rescue
	  $results.puts "<br>Unable to find last name element!"
	    else
		  $results.puts "<br>Successfully found last name!"
end

# ********************************* CI code base *********************************************

def ci_populate_form_first_name		# tests first name test field
  #sleep 1
  fname = "dave"
  case $env  # env = qa
  when "qa" 
    $browser.element(:id => '231fef7f-c134-4bb5-8331-35598004d68e').send_keys(fname)
  when "preview" 
    $browser.element(:id => '01a12e2b-38a1-4207-ad33-1f2ac450c44e').send_keys(fname)
  when "uat"
    $browser.element(:id => '231fef7f-c134-4bb5-8331-35598004d68e').send_keys(fname)
  when "live"
    $browser.element(:id => '01a12e2b-38a1-4207-ad33-1f2ac450c44e').send_keys(fname)   
  else
    $results.puts "<br>Error First Name ID has changed!" 
  end
    rescue
	  $results.puts "<br>Unable to find first name element!"
		 else
		   $results.puts "<br>Successfully found first name!"
end

def ci_populate_form_last_name		# tests last name text field
  case $env  # env = qa
  when "qa" 
    $browser.element(:id => 'b5589173-6cb3-4251-bcd7-66793b3a023d').send_keys("testtest")
  when "preview" 
    $browser.element(:id => '6fb0f1f5-7c89-4b74-a3a1-d0d5cda629bb').send_keys("testtest")
  when "uat"
    $browser.element(:id => 'b5589173-6cb3-4251-bcd7-66793b3a023d').send_keys("testtest")
  when "live"
    $browser.element(:id => '6fb0f1f5-7c89-4b74-a3a1-d0d5cda629bb').send_keys("testtest")
  else
    $results.puts "<br>Error Last Name ID has changed!" 
  end
  	rescue
	  $results.puts "<br>Unable to find last name element!"
	    else
		  $results.puts "<br>Successfully found last name!"
end

def ci_populate_form_email			# tests email address text field.
  part1 = "gaincap"
  part2 = "@mailinator.com"
  get_unique_number
  email = part1 + $unique_number + part2		# builds email address with unique number.
  case $env  # env = qa
  when "qa" 
    $browser.element(:id => 'cb88606c-c301-4722-98cc-f19a2e78162b').send_keys(email)
  when "preview" 
    $browser.element(:id => 'afbc255a-79fb-4ae2-b488-b86ede10224e').send_keys(email)
  when "uat"
    $browser.element(:id => 'cb88606c-c301-4722-98cc-f19a2e78162b').send_keys(email)
  when "live"
    $browser.element(:id => 'afbc255a-79fb-4ae2-b488-b86ede10224e').send_keys(email)
  else
    $results.puts "<br>Error email address ID has changed!" 
  end
   	rescue
	  $results.puts "<br>Unable to find email element!"
		else
		  $results.puts "<br>Successfully found email element!"
end

def ci_populate_form_phone_number
  # phone number test field - hard coded must change with country.
  case $env  # env = qa
  when "qa" 
    $browser.element(:id => '954fb4dc-9aa6-4ee9-a23f-a6a932fc68d8').send_keys("5556669898")
  when "preview" 
    $browser.element(:id => '4b0e2f36-9677-410c-9c80-5a6d1b41839b').send_keys("5556669898")
  when "uat"
    $browser.element(:id => '954fb4dc-9aa6-4ee9-a23f-a6a932fc68d8').send_keys("5556669898")
  when "live"
    $browser.element(:id => '4b0e2f36-9677-410c-9c80-5a6d1b41839b').send_keys("5556669898")
  else
    $results.puts "<br>Error Phone number ID has changed!" 
  end
   	rescue
	  $results.puts "<br>Unable to find phone number element!</br>"
	 	else
		  $results.puts "<br>Successfully found phone number element!"
end

def ci_set_country_dropdown	
  sleep 2
  case $env  # env = qa
  when "qa" 
    $browser.element(:xpath,"//*[contains(@id, '6b0f5f44_4ed6_495b_b4d7_d3dacc2df2f2')]").click
    $browser.send_keys ($country)
  when "preview" 
    $browser.element(:xpath,"//*[contains(@id, 'cede1480_db73_490d_aa6a_5d80f2a6dce8')]").click
    $browser.send_keys ($country)
  when "uat"
    $browser.element(:xpath,"//*[contains(@id, '6b0f5f44_4ed6_495b_b4d7_d3dacc2df2f2')]").click
    $browser.send_keys ($country)
  when "live"
    #sleep 1
	$browser.element(:xpath,"//*[contains(@id, 'cede1480_db73_490d_aa6a_5d80f2a6dce8')]").click
	sleep 1
    $browser.send_keys ($country)
	sleep 1
  else
    $results.puts "<br>Error Phone number ID has changed!" 
  end
  #sleep 1
	rescue
	  $results.puts "<br>Unable to set country drop-down box!"
	  get_unique_number 
	  $browser.screenshot.save "Submit_Page_dropdowm_Error"+$unique_number + ".png"
		else
		  $results.puts "<br>Successfully set country drop-down box!"
end

def ci_demo_form_submit
  #sleep 1
  $browser.send_keys :enter      
  # $browser.element.button(:xpath,"//*[contains(@class, 'form-submit form-buttonSubmit cta-btn blue')]").click
    sleep 4
	rescue
	  $results.puts "<br>Form Submit Failed!"
	  get_unique_number
	  $browser.screenshot.save "Submit_Page_Error" + $unique_number + ".png"
	    else
		  $results.puts "<br>Successfully clicked submit button!"
end

def ci_validate_confirm_page
  sleep 4
  title_from_page = $browser.title
  $results.puts "<br>title from Confirmation page = " + title_from_page
  expected_title = "Your Advantage Web Demo Account is now Active | City Index"
  #expected_title = "Advantage Web demo account creation error"
  $results.puts "<br>Expected Confirm title = " + expected_title
      if title_from_page == expected_title
      #expect($browser.title).to include("Your Advantage Web Demo Account is now Active | City Index")
	  $results.puts "<br>Pass - Demo form sign-up country = " + $country
	  $summary_results.puts "<br>Pass - Demo form sign-up country = " + $country
	  $test_pass_count = $test_pass_count + 1
        else 
		  $results.puts "<br>title values do not match!"
		  $test_failed_count = $test_failed_count + 1
		  error_title_confirm_page
      end
         rescue
           $results.puts "<br>Error validate_confirm_page code."
		     else	
               $results.puts "<br>Successfully validate_confirm_page"
end

def ci_negative_validate_confirm_page
  sleep 4
  title_from_page = $browser.title
  $results.puts "<br>title from Confirmation page = " + title_from_page
  expected_title = "Your Advantage Web Demo Account is now Active | City Index"
  #expected_title = "Advantage Web demo account creation error"
  $results.puts "<br>Expected Confirm title = " + expected_title
      if title_from_page == expected_title
      #expect($browser.title).to include("Your Advantage Web Demo Account is now Active | City Index")
	  $results.puts "<br>Pass - Demo form sign-up country = " + $country
	  $summary_results.puts "<br>Pass - Demo form sign-up country = " + $country
	  $test_failed_count = $test_failed_count + 1
        else 
		  $results.puts "<br>title values do not match!"
		  $test_pass_count = $test_pass_count + 1
	  end
         rescue
           $results.puts "<br>Error validate_confirm_page code."
		     else	
               $results.puts "<br>Successfully validate_confirm_page."
end

def ci_validate_submit_title_page
  #sleep 1
  title_from_page = $browser.title
  $results.puts "<br>title from Confirmation page = " + title_from_page
  expected_title = "Trading Account | Open Demo Trading Account | City Index UK"
  #expected_title = "Advantage Web demo account creation error"
  $results.puts "<br>Expected Submit title = " + expected_title
      if title_from_page == expected_title
        $results.puts "<br>Pass - Submit title page test."
	    $summary_results.puts "<br>Pass - Submit title page test."
          else 
		    $results.puts "<br>title values do not match!"
		    error_title_submit_page
      end
        rescue
          $results.puts "<br>Error validate Submit page title code."
		  
            else	
              $results.puts "<br>Successfully validate Submit page title."
end

def ci_validate_title_demo_signup
  #sleep 1
  title_from_page = $browser.title
  expected_title = "Trading Account | Open Demo Trading Account | City Index UK" 
  #expected_title = "Trade Error"
  $results.puts "<br>title expected = " + expected_title
  $results.puts "<br>title on page = " + title_from_page
  if title_from_page == expected_title
     #expect($browser.title).to include("Trading Account | Open Demo Trading Account | City Index UK")
	 $results.puts "<br>Validated Demo sign-up form's title"
	 else  
	   $results.puts "<br>title values do not match!"
	   error_title_demo_signup_page
  end   
    rescue
	  
      $results.puts "<br>Error validating Demo form's title."
        else
          $results.puts "<br>Successfully validated demo form's title."
end

def ci_form_demo_test
  # This is a positive test for the CI Demo form
  site_connect_ci
  accept_cookie_policy
  get_server_name
  ci_validate_title_demo_signup
  ci_populate_form_first_name
  ci_populate_form_last_name
  ci_populate_form_email
  ci_populate_form_phone_number
  ci_set_country_dropdown
  ci_demo_form_submit
  ci_validate_confirm_page
end

# ****************** CI Negative tests (Missing Information)*******************************

def ci_negative_demo_form_submit
  #sleep 4
  $browser.send_keys :enter      
  # $browser.element.button(:xpath,"//*[contains(@class, 'form-submit form-buttonSubmit cta-btn blue')]").click
    sleep 4
	rescue
	  $results.puts "<br>Form Submit Failed! for CI Negative Demo Form!"
	  $summary_results.puts "<br>Form Submit Failed! for CI Negative Demo Form!"
	  get_unique_number
	  $browser.screenshot.save "CI_Negative_Submit_Page_Error" + $unique_number + ".png"
	    else
		  $results.puts "<br>Successfully clicked submit button!"
		  $summary_results.puts "<br>Pass - Negative Test."
end

def ci_missing_first_name
# This is a negative test for the CI Demo form
  $test_count = $test_count + 1
  $test_count1 = $test_count 
  setup_negative_test
  site_connect_ci
  accept_cookie_policy
  get_server_name
  ci_validate_title_demo_signup
  $results.puts "<br>Missing First Name Test, Brand = " + $brand 
  ci_populate_form_last_name
  ci_populate_form_email
  ci_populate_form_phone_number
  ci_negative_demo_form_submit
  ci_negative_validate_confirm_page
  $results.puts "<br>***** CI Missing First Name Test Completed Status:" 
  $results.puts "<br>Total Test Executed Pass / Fail (Running Total for Test Audit Trail.)"
  $results.puts "<br>Test Count = " + $test_count1.to_s 
  $results.puts "<br>Test Pass Count = " + $test_pass_count.to_s 
  $results.puts "<br>Test Failed Count = " + $test_failed_count.to_s 
  $summary_results.puts "<br>***** CI Missing First Name Test Completed Status:"
  $summary_results.puts "<br>Total Test Executed Pass / Fail (Running Total for Test Audit Trail.)"
  $summary_results.puts "<br>Test Count = " + $test_count1.to_s 
  $summary_results.puts "<br>Test Pass Count = " + $test_pass_count.to_s 
  $summary_results.puts "<br>Test Failed Count = " + $test_failed_count.to_s 
  $results.puts "<br>End CI Negative Form Test Missing First Name for Country = " + $country 
  $summary_results.puts "<br>******* End CI Missing First Name Test. **************************"
 end 

def ci_missing_last_name
# This is a negative test for the CI Demo form
  $test_count = $test_count + 1
  $test_count1 = $test_count 
  setup_negative_test
  site_connect_ci
  accept_cookie_policy
  get_server_name
  ci_validate_title_demo_signup
  $results.puts "<br>Missing last name test, brand = " + $brand 
  ci_populate_form_first_name
  ci_populate_form_email
  ci_populate_form_phone_number
  ci_negative_demo_form_submit
  ci_negative_validate_confirm_page
  $results.puts "<br>***** CI Missing Last Name Test Completed Status:" 
  $results.puts "<br>Total Test Executed Pass / Fail (Running Total for Test Audit Trail.)"
  $results.puts "<br>Test Count = " + $test_count1.to_s 
  $results.puts "<br>Test Pass Count = " + $test_pass_count.to_s 
  $results.puts "<br>Test Failed Count = " + $test_failed_count.to_s 
  $summary_results.puts "<br>***** CI Missing Last Name Test Completed Status:"
  $summary_results.puts "<br>Total Test Executed Pass / Fail (Running Total for Test Audit Trail.)"
  $summary_results.puts "<br>Test Count = " + $test_count1.to_s 
  $summary_results.puts "<br>Test Pass Count = " + $test_pass_count.to_s 
  $summary_results.puts "<br>Test Failed Count = " + $test_failed_count.to_s 
  $results.puts "<br>End CI Negative Form Test Missing First Name for Country = " + $country 
  $summary_results.puts "<br>******* End CI Missing Last Name Test. **************************"
end 

def ci_missing_email
# This is a negative test for the CI Demo form
  $test_count = $test_count + 1
  $test_count1 = $test_count 
  setup_negative_test
  site_connect_ci
  accept_cookie_policy
  get_server_name
  ci_validate_title_demo_signup
  $results.puts "<br>Missing email test, brand = " + $brand 
  ci_populate_form_first_name
  ci_populate_form_last_name
  ci_populate_form_phone_number
  ci_negative_demo_form_submit
  ci_negative_validate_confirm_page
  $results.puts "<br>***** CI Missing Email Test Completed Status:" 
  $results.puts "<br>Total Test Executed Pass / Fail (Running Total for Test Audit Trail.)"
  $results.puts "<br>Test Count = " + $test_count1.to_s 
  $results.puts "<br>Test Pass Count = " + $test_pass_count.to_s 
  $results.puts "<br>Test Failed Count = " + $test_failed_count.to_s 
  $summary_results.puts "<br>***** CI Missing Email Test Completed Status:"
  $summary_results.puts "<br>Total Test Executed Pass / Fail (Running Total for Test Audit Trail.)"
  $summary_results.puts "<br>Test Count = " + $test_count1.to_s 
  $summary_results.puts "<br>Test Pass Count = " + $test_pass_count.to_s 
  $summary_results.puts "<br>Test Failed Count = " + $test_failed_count.to_s 
  $results.puts "<br>End CI Negative Form Test Missing Email for Country = " + $country 
  $summary_results.puts "<br>******* End CI Missing Email Test. *******************************"
  
end 

def ci_missing_phone_number
# This is a negative test for the CI Demo form
  $test_count = $test_count + 1
  $test_count1 = $test_count 
  setup_negative_test
  site_connect_ci
  accept_cookie_policy
  get_server_name
  ci_validate_title_demo_signup
  $results.puts "<br>Missing phone number test, brand = " + $brand 
  ci_populate_form_first_name
  ci_populate_form_last_name
  ci_populate_form_email
  ci_negative_demo_form_submit
  ci_negative_validate_confirm_page
  $results.puts "***** <br>CI Missing Phone Number Test Completed Status:" 
  $results.puts "<br>Total Test Executed Pass / Fail (Running Total for Test Audit Trail.)"
  $results.puts "<br>Test Count = " + $test_count1.to_s 
  $results.puts "<br>Test Pass Count = " + $test_pass_count.to_s 
  $results.puts "<br>Test Failed Count = " + $test_failed_count.to_s 
  $summary_results.puts "<br>***** CI Missing Phone Number Test Completed Status:"
  $summary_results.puts "<br>Total Test Executed Pass / Fail (Running Total for Test Audit Trail.)"
  $summary_results.puts "<br>Test Count = " + $test_count1.to_s 
  $summary_results.puts "<br>Test Pass Count = " + $test_pass_count.to_s 
  $summary_results.puts "<br>Test Failed Count = " + $test_failed_count.to_s 
  $results.puts "<br>End CI Negative Form Test Missing Phone Number Country = " + $country 
  $summary_results.puts "<br>******* End CI Missing Phone Number Test. ***********************"
end 

# ************* MT4 Negative Tests (Missing Information) ***********************************

def mt_negative_demo_form_submit
  sleep 4
  $browser.send_keys :enter      
  # $browser.element.button(:xpath,"//*[contains(@class, 'form-submit form-buttonSubmit cta-btn blue')]").click
    #sleep 4
	  rescue
	    $results.puts "<br>Form Submit Failed! for MT4 Negative Demo Form!"
	    $summary_results.puts "<br>Form Submit Failed! for MT4 Negative Demo Form!"
		# $browser.element.button(:xpath,"//*[contains(@class, 'form-submit form-buttonSubmit cta-btn blue')]").click
	    get_unique_number
	    $browser.screenshot.save "MT4_Negative_Submit_Page_Error" + $unique_number + ".png"
	      else
		    $results.puts "<br>Successfully clicked submit button!"
		    $summary_results.puts "<br>Pass - Negative Test MT4"
end

def mt_missing_first_name
# This is a negative test for the MT4 Demo form
  $test_count = $test_count + 1
  $test_count1 = $test_count 
  $results.puts "<br>Starting MT4 Missing First Name Test." 
  # setup_negative_test
  site_connect_ci
  accept_cookie_policy
  get_server_name
  mt_validate_title_demo_signup
  mt_populate_form_last_name
  mt_populate_form_email
  mt_populate_form_phone_number
  mt_negative_demo_form_submit
  mt_negative_validate_confirm_page
  $results.puts "<br>***** MT4 Missing First Name Test Completed Status:" 
  $results.puts "<br>Total Test Executed Pass / Fail (Running Total for Test Audit Trail.)"
  $results.puts "<br>Test Count = " + $test_count1.to_s 
  $results.puts "<br>Test Pass Count = " + $test_pass_count.to_s 
  $results.puts "<br>Test Failed Count = " + $test_failed_count.to_s 
  $summary_results.puts "<br>***** MT4 Missing First Name Test Completed Status:"
  $summary_results.puts "<br>Total Test Executed Pass / Fail (Running Total for Test Audit Trail.)"
  $summary_results.puts "<br>Test Count = " + $test_count1.to_s 
  $summary_results.puts "<br>Test Pass Count = " + $test_pass_count.to_s 
  $summary_results.puts "<br>Test Failed Count = " + $test_failed_count.to_s 
  $results.puts "<br>End MT4 Negative Form Test Missing First Name for Country = " + $country 
  $summary_results.puts "<br>******* End MT4 Missing First Name Test. **************************"
end 

def mt_missing_last_name
# This is a negative test for the MT4 CI Demo form
  $test_count = $test_count + 1
  $test_count1 = $test_count 
  $results.puts "<br>Starting MT4 Missing Last Name Test."
  setup_negative_test
  site_connect_ci
  accept_cookie_policy
  get_server_name
  mt_validate_title_demo_signup
  $results.puts "<br>Missing last name test, brand = " + $brand 
  mt_populate_form_first_name
  mt_populate_form_email
  mt_populate_form_phone_number
  mt_negative_demo_form_submit
  mt_negative_validate_confirm_page
  $results.puts "<br>***** MT4 Missing Last Name Test Completed Status:" 
  $results.puts "<br>Total Test Executed Pass / Fail (Running Total for Test Audit Trail.)"
  $results.puts "<br>Test Count = " + $test_count1.to_s 
  $results.puts "<br>Test Pass Count = " + $test_pass_count.to_s 
  $results.puts "<br>Test Failed Count = " + $test_failed_count.to_s 
  $summary_results.puts "<br>***** MT4 Missing Last Name Test Completed Status:"
  $summary_results.puts "<br>Total Test Executed Pass / Fail (Running Total for Test Audit Trail.)"
  $summary_results.puts "<br>Test Count = " + $test_count1.to_s 
  $summary_results.puts "<br>Test Pass Count = " + $test_pass_count.to_s 
  $summary_results.puts "<br>Test Failed Count = " + $test_failed_count.to_s 
  $results.puts "<br>End MT4 Negative Form Test Missing First Name for Country = " + $country 
  $summary_results.puts "<br>******* End MT4 Missing Last Name Test. **************************"
end 

def mt_missing_email
# This is a negative test for the Mt4 CI Demo form
  $test_count = $test_count + 1
  $test_count1 = $test_count 
  $results.puts "<br>Starting MT4 Missing Email Test."
  setup_negative_test
  site_connect_ci
  accept_cookie_policy
  get_server_name
  mt_validate_title_demo_signup
  $results.puts "Missing email test, brand = " + $brand 
  mt_populate_form_first_name
  mt_populate_form_last_name
  mt_populate_form_phone_number
  mt_negative_demo_form_submit
  mt_negative_validate_confirm_page
  $results.puts "<br>***** MT4 Missing Email Test Completed Status:" 
  $results.puts "<br>Total Test Executed Pass / Fail (Running Total for Test Audit Trail.)"
  $results.puts "<br>Test Count = " + $test_count1.to_s 
  $results.puts "<br>Test Pass Count = " + $test_pass_count.to_s 
  $results.puts "<br>Test Failed Count = " + $test_failed_count.to_s 
  $summary_results.puts "<br>***** MT4 Missing Email Test Completed Status:"
  $summary_results.puts "<br>Total Test Executed Pass / Fail (Running Total for Test Audit Trail.)"
  $summary_results.puts "<br>Test Count = " + $test_count1.to_s 
  $summary_results.puts "<br>Test Pass Count = " + $test_pass_count.to_s 
  $summary_results.puts "<br>Test Failed Count = " + $test_failed_count.to_s 
  $results.puts "<br>End MT4 Negative Form Test Missing Email for Country = " + $country 
  $summary_results.puts "<br>******* End MT4 Missing Email Test. ******************************"
end 

def mt_missing_phone_number
  $test_count = $test_count + 1
  $test_count1 = $test_count 
  $results.puts "<br>Starting MT4 Missing Phone Number Test." 
  setup_negative_test
  site_connect_ci
  accept_cookie_policy
  get_server_name
  mt_validate_title_demo_signup
  $results.puts "<br>Missing phone number test, brand = " + $brand 
  mt_populate_form_first_name
  mt_populate_form_email
  mt_populate_form_last_name
  mt_negative_demo_form_submit
  mt_negative_validate_confirm_page
  $results.puts "<br>***** MT4 Missing Phone Number Test Completed Status:" 
  $results.puts "<br>Total Test Executed Pass / Fail (Running Total for Test Audit Trail.)"
  $results.puts "<br>Test Count = " + $test_count1.to_s 
  $results.puts "<br>Test Pass Count = " + $test_pass_count.to_s 
  $results.puts "<br>Test Failed Count = " + $test_failed_count.to_s 
  $summary_results.puts "<br>***** MT4 Missing Phone Number Test Completed Status:"
  $summary_results.puts "<br>Total Test Executed Pass / Fail (Running Total for Test Audit Trail.)"
  $summary_results.puts "<br>Test Count = " + $test_count1.to_s 
  $summary_results.puts "<br>Test Pass Count = " + $test_pass_count.to_s 
  $summary_results.puts "<br>Test Failed Count = " + $test_failed_count.to_s 
  $results.puts "<br>End MT4 Negative Form Test Missing Phone Number Country = " + $country 
  $summary_results.puts "<br>******* End MT4 Missing Phone Number Test. ***********************"
end 

# ************** MT4 Negative Tests (Wrong Information such as min/max)********************

def mt_first_name_with_numbers
# This is a negative test for the MT4 CI Demo form (only letters are valid).
  $test_count = $test_count + 1
  $test_count1 = $test_count 
  $results.puts "<br>Starting MT4 First Name has number Test."
  setup_negative_test
  site_connect_ci
  accept_cookie_policy
  get_server_name
  mt_validate_title_demo_signup
  $results.puts "<br>first name with number test, brand = " + $brand 
  mt_populate_form_first_name_with_numbers
  mt_populate_form_last_name
  mt_populate_form_email
  mt_populate_form_phone_number
  mt_negative_demo_form_submit
  mt_negative_validate_confirm_page
  $results.puts "<br>***** MT4 First Name has Number Test Completed, Status:" 
  $results.puts "<br>Total Test Executed Pass / Fail (Running Total for Test Audit Trail.)"
  $results.puts "<br> Test Count = " + $test_count1.to_s 
  $results.puts "<br>Test Pass Count = " + $test_pass_count.to_s 
  $results.puts "<br>Test Failed Count = " + $test_failed_count.to_s 
  $summary_results.puts "<br>***** MT4 First Name has Number Test Completed, Status:"
  $summary_results.puts "<br>Total Test Executed Pass / Fail (Running Total for Test Audit Trail.)"
  $summary_results.puts "<br>Test Count = " + $test_count1.to_s 
  $summary_results.puts "<br>Test Pass Count = " + $test_pass_count.to_s 
  $summary_results.puts "<br>Test Failed Count = " + $test_failed_count.to_s 
  $results.puts "End MT4 Negative Form Test First Name has Number, Country = " + $country 
  $summary_results.puts "<br>******* End MT4 First Name has Number Test. ***********************"
end

def mt_last_name_with_numbers
# This is a negative test for the MT4 CI Demo form
  $test_count = $test_count + 1
  $test_count1 = $test_count 
  $results.puts "<br>Starting MT4 Last Name with numbers Test."
  setup_negative_test
  site_connect_ci
  accept_cookie_policy
  get_server_name
  mt_validate_title_demo_signup
  $results.puts "<br>last name with numbers test, brand = " + $brand 
  mt_populate_form_first_name
  mt_populate_form_last_name_with_numbers
  mt_populate_form_email
  mt_populate_form_phone_number
  mt_negative_demo_form_submit
  mt_negative_validate_confirm_page
  $results.puts "<br>***** MT4 last Name has Number Test Completed, Status:" 
  $results.puts "<br>Total Test Executed Pass / Fail (Running Total for Test Audit Trail.)"
  $results.puts "<br>Test Count = " + $test_count1.to_s 
  $results.puts "<br>Test Pass Count = " + $test_pass_count.to_s 
  $results.puts "<br>Test Failed Count = " + $test_failed_count.to_s 
  $summary_results.puts "<br>***** MT4 Last Name has Number Test Completed, Status:"
  $summary_results.puts "<br>Total Test Executed Pass / Fail (Running Total for Test Audit Trail.)"
  $summary_results.puts "<br>Test Count = " + $test_count1.to_s 
  $summary_results.puts "<br>Test Pass Count = " + $test_pass_count.to_s 
  $summary_results.puts "<br>Test Failed Count = " + $test_failed_count.to_s 
  $results.puts "<br>End MT4 Negative Form Test Last Name has Number, Country = " + $country 
  $summary_results.puts "<br>******* End MT4 Last Name has Number Test. ************************"
end

def mt_email_invalid_format
# This is a negative test for the Mt4 CI Demo form
  $test_count = $test_count + 1
  $test_count1 = $test_count 
  $results.puts "<br>Starting MT4 Email invalid format Test."
  setup_negative_test
  site_connect_ci
  accept_cookie_policy
  get_server_name
  mt_validate_title_demo_signup
  $results.puts "<br>Email invalid format test, brand = " + $brand 
  mt_populate_form_first_name
  mt_populate_form_last_name
  mt_populate_form_email_invalid_format
  mt_populate_form_phone_number
  mt_negative_demo_form_submit
  mt_negative_validate_confirm_page
  $results.puts "<br>***** MT4 Email format invalid Test Completed, Status:" 
  $results.puts "<br>Total Test Executed Pass / Fail (Running Total for Test Audit Trail.)"
  $results.puts "<br>Test Count = " + $test_count1.to_s 
  $results.puts "<br>Test Pass Count = " + $test_pass_count.to_s 
  $results.puts "<br>Test Failed Count = " + $test_failed_count.to_s 
  $summary_results.puts "<br>***** MT4 Email Format invalid Test Completed, Status:"
  $summary_results.puts "<br>Total Test Executed Pass / Fail (Running Total for Test Audit Trail.)"
  $summary_results.puts "<br>Test Count = " + $test_count1.to_s 
  $summary_results.puts "<br>Test Pass Count = " + $test_pass_count.to_s 
  $summary_results.puts "<br>Test Failed Count = " + $test_failed_count.to_s 
  $results.puts "<br>End MT4 Negative Form Test Email Format invalid, Country = " + $country 
  $summary_results.puts "<br>******* End MT4 Email Format invalid Test. ************************"
end

def mt_phone_invalid_format
# This is a negative test for the Mt4 CI Demo form
  $test_count = $test_count + 1
  $test_count1 = $test_count 
  $results.puts "<br>Starting MT4 Email invalid format Test."
  setup_negative_test
  site_connect_ci
  accept_cookie_policy
  get_server_name
  mt_validate_title_demo_signup
  $results.puts "<br>Email invalid format test, brand = " + $brand 
  mt_populate_form_first_name
  mt_populate_form_last_name
  mt_populate_form_email
  mt_populate_form_phone_number_invalid_format
  mt_negative_demo_form_submit
  mt_negative_validate_confirm_page
  $results.puts "<br>***** MT4 Phone format invalid Test Completed, Status:" 
  $results.puts "<br>Total Test Executed Pass / Fail (Running Total for Test Audit Trail.)"
  $results.puts "<br>Test Count = " + $test_count1.to_s 
  $results.puts "<br>Test Pass Count = " + $test_pass_count.to_s 
  $results.puts "<br>Test Failed Count = " + $test_failed_count.to_s 
  $summary_results.puts "<br>***** MT4 Phone Format invalid Test Completed, Status:"
  $summary_results.puts "<br>Total Test Executed Pass / Fail (Running Total for Test Audit Trail.)"
  $summary_results.puts "<br>Test Count = " + $test_count1.to_s 
  $summary_results.puts "<br>Test Pass Count = " + $test_pass_count.to_s 
  $summary_results.puts "<br>Test Failed Count = " + $test_failed_count.to_s 
  $results.puts "<br>End MT4 Negative Form Test Phone Format invalid, Country = " + $country 
  $summary_results.puts "<br>******* End MT4 Phone Format invalid Test. ************************"
end

# ************** CI Negative Tests (Wrong Information such as min/max)*******************

def ci_first_name_with_numbers
# This is a negative test for the CI Demo form
  $test_count = $test_count + 1
  $test_count1 = $test_count 
  $results.puts "<br>Starting CI First Name has number Test."
  setup_negative_test
  site_connect_ci
  accept_cookie_policy
  get_server_name
  ci_validate_title_demo_signup
  $results.puts "<br>first name with numbers test, brand = " + $brand 
  ci_populate_form_first_name_with_numbers
  ci_populate_form_last_name
  ci_populate_form_email
  ci_populate_form_phone_number
  ci_negative_demo_form_submit
  ci_negative_validate_confirm_page
  $results.puts "<br>***** CI First Name has Number Test Completed, Status:" 
  $results.puts "<br>Total Test Executed Pass / Fail (Running Total for Test Audit Trail.)"
  $results.puts "<br>Test Count = " + $test_count1.to_s 
  $results.puts "<br>Test Pass Count = " + $test_pass_count.to_s 
  $results.puts "<br>Test Failed Count = " + $test_failed_count.to_s 
  $summary_results.puts "<br>***** CI First Name has Number Test Completed, Status:"
  $summary_results.puts "<br>Total Test Executed Pass / Fail (Running Total for Test Audit Trail.)"
  $summary_results.puts "<br>Test Count = " + $test_count1.to_s 
  $summary_results.puts "<br>Test Pass Count = " + $test_pass_count.to_s 
  $summary_results.puts "<br>Test Failed Count = " + $test_failed_count.to_s 
  $results.puts "<br>End CI Negative Form Test First Name has Number, Country = " + $country 
  $summary_results.puts "<br>******* End CI First Name has Number Test. ************************"
end

def ci_last_name_with_numbers
# This is a negative test for the CI Demo form
  $test_count = $test_count + 1
  $test_count1 = $test_count 
  $results.puts "<br>Starting CI Last Name with numbers Test."
  setup_negative_test
  site_connect_ci
  accept_cookie_policy
  get_server_name
  ci_validate_title_demo_signup
  $results.puts "<br>last name with numbers test, brand = " + $brand 
  ci_populate_form_first_name
  ci_populate_form_last_name_with_numbers
  ci_populate_form_email
  ci_populate_form_phone_number
  ci_negative_demo_form_submit
  ci_negative_validate_confirm_page
  $results.puts "<br>***** CI last Name has Number Test Completed, Status:" 
  $results.puts "<br>Total Test Executed Pass / Fail (Running Total for Test Audit Trail.)"
  $results.puts "<br>Test Count = " + $test_count1.to_s 
  $results.puts "<br>Test Pass Count = " + $test_pass_count.to_s 
  $results.puts "<br>Test Failed Count = " + $test_failed_count.to_s 
  $summary_results.puts "<br>***** CI Last Name has Number Test Completed, Status:"
  $summary_results.puts "<br>Total Test Executed Pass / Fail (Running Total for Test Audit Trail.)"
  $summary_results.puts "<br>Test Count = " + $test_count1.to_s 
  $summary_results.puts "<br>Test Pass Count = " + $test_pass_count.to_s 
  $summary_results.puts "<br>Test Failed Count = " + $test_failed_count.to_s 
  $results.puts "<br>End CI Negative Form Test Last Name has Number, Country = " + $country 
  $summary_results.puts "<br>******* End CI Last Name has Number Test. *************************"
end

def ci_email_invalid_format
# This is a negative test for the CI Demo form
  $test_count = $test_count + 1
  $test_count1 = $test_count 
  $results.puts "<br>Starting CI Email invalid format Test."
  setup_negative_test
  site_connect_ci
  accept_cookie_policy
  get_server_name
  ci_validate_title_demo_signup
  $results.puts "<br>Email invalid format test, brand = " + $brand 
  ci_populate_form_first_name
  ci_populate_form_last_name
  ci_populate_form_email_invalid_format
  ci_populate_form_phone_number
  ci_negative_demo_form_submit
  ci_negative_validate_confirm_page
  $results.puts "<br>***** CI Email format invalid Test Completed, Status:" 
  $results.puts "<br>Total Test Executed Pass / Fail (Running Total for Test Audit Trail.)"
  $results.puts "<br>Test Count = " + $test_count1.to_s 
  $results.puts "<br>Test Pass Count = " + $test_pass_count.to_s 
  $results.puts "<br>Test Failed Count = " + $test_failed_count.to_s 
  $summary_results.puts "<br>***** CI Email Format invalid Test Completed, Status:"
  $summary_results.puts "<br>Total Test Executed Pass / Fail (Running Total for Test Audit Trail.)"
  $summary_results.puts "<br>Test Count = " + $test_count1.to_s 
  $summary_results.puts "<br>Test Pass Count = " + $test_pass_count.to_s 
  $summary_results.puts "<br>Test Failed Count = " + $test_failed_count.to_s 
  $results.puts "<br>End CI Negative Form Test Email Format invalid, Country = " + $country 
  $summary_results.puts "<br>******* End CI Email Format invalid Test. ************************"
end

def ci_phone_invalid_format
# This is a negative test for the CI Demo form
  $test_count = $test_count + 1
  $test_count1 = $test_count 
  $results.puts "<br>Starting CI Email invalid format Test."
  setup_negative_test
  site_connect_ci
  accept_cookie_policy
  get_server_name
  ci_validate_title_demo_signup
  $results.puts "<br>Email invalid format test, brand = " + $brand 
  ci_populate_form_first_name
  ci_populate_form_last_name
  ci_populate_form_email
  ci_populate_form_phone_number_invalid_format
  ci_negative_demo_form_submit
  ci_negative_validate_confirm_page
  $results.puts "<br>***** CI Phone format invalid Test Completed, Status:" 
  $results.puts "<br>Total Test Executed Pass / Fail (Running Total for Test Audit Trail.)"
  $results.puts "<br>Test Count = " + $test_count1.to_s 
  $results.puts "<br>Test Pass Count = " + $test_pass_count.to_s 
  $results.puts "<br>Test Failed Count = " + $test_failed_count.to_s 
  $summary_results.puts "<br>***** CI Phone Format invalid Test Completed, Status:"
  $summary_results.puts "<br>Total Test Executed Pass / Fail (Running Total for Test Audit Trail.)"
  $summary_results.puts "<br>Test Count = " + $test_count1.to_s 
  $summary_results.puts "<br>Test Pass Count = " + $test_pass_count.to_s 
  $summary_results.puts "<br>Test Failed Count = " + $test_failed_count.to_s 
  $results.puts "<br>End CI Negative Form Test Phone Format invalid, Country = " + $country 
  $summary_results.puts "<br>******* End CI Phone Format invalid Test. *************************"
end

# ************************ MT4 Negative Tests invalid information.*************************

def mt_51_char_first_name
# This is a negative test for the Mt4 CI Demo form
  $test_count = $test_count + 1
  $test_count1 = $test_count 
  $results.puts "<br>Starting MT4 51 char invalid format Test."
  setup_negative_test
  site_connect_ci
  accept_cookie_policy
  get_server_name
  mt_validate_title_demo_signup
  $results.puts "<br>51 char invalid format test, brand = " + $brand 
  mt_populate_form_first_name_51_char
  mt_populate_form_last_name
  mt_populate_form_email
  mt_populate_form_phone_number
  mt_negative_demo_form_submit
  mt_negative_validate_confirm_page
  $results.puts "<br>***** MT4 51 char First Name Test Completed, Status:" 
  $results.puts "<br>Total Test Executed Pass / Fail (Running Total for Test Audit Trail.)"
  $results.puts "<br>Test Count = " + $test_count1.to_s 
  $results.puts "<br>Test Pass Count = " + $test_pass_count.to_s 
  $results.puts "<br>Test Failed Count = " + $test_failed_count.to_s 
  $summary_results.puts "<br>***** MT4 51 char First Name Test Completed, Status:"
  $summary_results.puts "<br>Total Test Executed Pass / Fail (Running Total for Test Audit Trail.)"
  $summary_results.puts "<br>Test Count = " + $test_count1.to_s 
  $summary_results.puts "<br>Test Pass Count = " + $test_pass_count.to_s 
  $summary_results.puts "<br>Test Failed Count = " + $test_failed_count.to_s 
  $results.puts "<br>End MT4 Negative Form Test 51 char First Name, Country = " + $country 
  $summary_results.puts "<br>******* End MT4 51 char First Name Test. ************************"
end

def mt_51_char_last_name
# This is a negative test for the MT4 CI Demo form
  $test_count = $test_count + 1
  $test_count1 = $test_count 
  $results.puts "<br>Starting MT4 Last Name with numbers Test."
  setup_negative_test
  site_connect_ci
  accept_cookie_policy
  get_server_name
  mt_validate_title_demo_signup
  $results.puts "<br>last name with 51 char test, brand = " + $brand 
  mt_populate_form_first_name
  mt_populate_form_last_name_51_char
  mt_populate_form_email
  mt_populate_form_phone_number 
  mt_negative_demo_form_submit
  mt_negative_validate_confirm_page
  $results.puts "<br>***** MT4 51 char Last Name Test Completed, Status:" 
  $results.puts "<br>Total Test Executed Pass / Fail (Running Total for Test Audit Trail.)"
  $results.puts "<br>Test Count = " + $test_count1.to_s 
  $results.puts "<br>Test Pass Count = " + $test_pass_count.to_s 
  $results.puts "<br>Test Failed Count = " + $test_failed_count.to_s 
  $summary_results.puts "<br>***** MT4 51 char Last Name Test Completed, Status:"
  $summary_results.puts "<br>Total Test Executed Pass / Fail (Running Total for Test Audit Trail.)"
  $summary_results.puts "<br>Test Count = " + $test_count1.to_s 
  $summary_results.puts "<br>Test Pass Count = " + $test_pass_count.to_s 
  $summary_results.puts "<br>Test Failed Count = " + $test_failed_count.to_s 
  $results.puts "<br>End MT4 Negative Form Test 51 char Last Name, Country = " + $country
  $summary_results.puts "<br>******* End MT4 51 char Last Name Test. ***************************"
end

def mt_one_char_first_name
# This is a negative test for the Mt4 CI Demo form
  $test_count = $test_count + 1
  $test_count1 = $test_count 
  $results.puts "<br>Starting MT4 51 char invalid format Test."
  setup_negative_test
  site_connect_ci
  accept_cookie_policy
  get_server_name
  mt_validate_title_demo_signup
  $results.puts "<br>51 char invalid format test, brand = " + $brand 
  mt_populate_form_first_name_one_char
  mt_populate_form_last_name
  mt_populate_form_email
  mt_populate_form_phone_number
  mt_negative_demo_form_submit
  mt_negative_validate_confirm_page
  $results.puts "<br>***** MT4 one char First Name Test Completed, Status:" 
  $results.puts "<br>Total Test Executed Pass / Fail (Running Total for Test Audit Trail.)"
  $results.puts "<br>Test Count = " + $test_count1.to_s 
  $results.puts "<br>Test Pass Count = " + $test_pass_count.to_s 
  $results.puts "<br>Test Failed Count = " + $test_failed_count.to_s 
  $summary_results.puts "<br>***** MT4 one char First Name Test Completed, Status:"
  $summary_results.puts "<br>Total Test Executed Pass / Fail (Running Total for Test Audit Trail.)"
  $summary_results.puts "<br>Test Count = " + $test_count1.to_s 
  $summary_results.puts "<br>Test Pass Count = " + $test_pass_count.to_s 
  $summary_results.puts "<br>Test Failed Count = " + $test_failed_count.to_s 
  $results.puts "<br>End MT4 Negative Form Test one char First Name, Country = " + $country 
  $summary_results.puts "<br>******* End MT4 one char First Name Test. **************************"
end

def mt_one_char_last_name
# This is a negative test for the MT4 CI Demo form
  $test_count = $test_count + 1
  $test_count1 = $test_count 
  $results.puts "<br>Starting MT4 Last Name with numbers Test."
  setup_negative_test
  site_connect_ci
  accept_cookie_policy
  get_server_name
  mt_validate_title_demo_signup
  $results.puts "<br>last name with 51 char test, brand = " + $brand 
  mt_populate_form_first_name
  mt_populate_form_last_name_one_char
  mt_populate_form_email
  mt_populate_form_phone_number 
  mt_negative_demo_form_submit
  mt_negative_validate_confirm_page
  $results.puts "<br>***** MT4 one char Last Name Test Completed, Status:" 
  $results.puts "<br>Total Test Executed Pass / Fail (Running Total for Test Audit Trail.)"
  $results.puts "<br>Test Count = " + $test_count1.to_s 
  $results.puts "<br>Test Pass Count = " + $test_pass_count.to_s 
  $results.puts "<br>Test Failed Count = " + $test_failed_count.to_s 
  $summary_results.puts "<br>***** MT4 one char Last Name Test Completed, Status:"
  $summary_results.puts "<br>Total Test Executed Pass / Fail (Running Total for Test Audit Trail.)"
  $summary_results.puts "<br>Test Count = " + $test_count1.to_s 
  $summary_results.puts "<br>Test Pass Count = " + $test_pass_count.to_s 
  $summary_results.puts "<br>Test Failed Count = " + $test_failed_count.to_s 
  $results.puts "<br>End MT4 Negative Form Test one char Last Name, Country = " + $country 
  $summary_results.puts "<br>******* End MT4 one char Last Name Test. ***************************"
end

# ************************ MT4 Negative Tests invalid information.*************************

def ci_51_char_first_name
# This is a negative test for the CI Demo form
  $test_count = $test_count + 1
  $test_count1 = $test_count 
  $results.puts "Starting CI 51 char invalid format Test."
  setup_negative_test
  site_connect_ci
  accept_cookie_policy
  get_server_name
  ci_validate_title_demo_signup
  $results.puts "<br>51 char invalid format test, brand = " + $brand 
  ci_populate_form_first_name_51_char
  ci_populate_form_last_name
  ci_populate_form_email
  ci_populate_form_phone_number
  ci_negative_demo_form_submit
  ci_negative_validate_confirm_page
  $results.puts "<br>***** CI 51 char Last Name Test Completed, Status:" 
  $results.puts "<br>Total Test Executed Pass / Fail (Running Total for Test Audit Trail.)"
  $results.puts "<br>Test Count = " + $test_count1.to_s 
  $results.puts "<br>Test Pass Count = " + $test_pass_count.to_s 
  $results.puts "<br>Test Failed Count = " + $test_failed_count.to_s 
  $summary_results.puts "<br>***** CI 51 char Last Name Test Completed, Status:"
  $summary_results.puts "<br>Total Test Executed Pass / Fail (Running Total for Test Audit Trail.)"
  $summary_results.puts "<br>Test Count = " + $test_count1.to_s 
  $summary_results.puts "<br>Test Pass Count = " + $test_pass_count.to_s 
  $summary_results.puts "<br>Test Failed Count = " + $test_failed_count.to_s 
  $results.puts "<br>End CI Negative Form Test 51 char Last Name, Country = " + $country 
  $summary_results.puts "<br>******* End CI 51 char Last Name Test. ***************************"
end

def ci_51_char_last_name
# This is a negative test for the CI Demo form
  $test_count = $test_count + 1
  $test_count1 = $test_count 
  $results.puts "<br>Starting CI Last Name with numbers Test."
  setup_negative_test
  site_connect_ci
  accept_cookie_policy
  get_server_name
  ci_validate_title_demo_signup
  $results.puts "<br>last name with 51 char test, brand = " + $brand 
  ci_populate_form_first_name
  ci_populate_form_last_name_51_char
  ci_populate_form_email
  ci_populate_form_phone_number 
  ci_negative_demo_form_submit
  ci_negative_validate_confirm_page
  $results.puts "<br>***** CI 51 char Last Name Test Completed, Status:" 
  $results.puts "<br>Total Test Executed Pass / Fail (Running Total for Test Audit Trail.)"
  $results.puts "<br>Test Count = " + $test_count1.to_s 
  $results.puts "<br>Test Pass Count = " + $test_pass_count.to_s 
  $results.puts "<br>Test Failed Count = " + $test_failed_count.to_s 
  $summary_results.puts "<br>***** CI 51 char Last Name Test Completed, Status:"
  $summary_results.puts "<br>Total Test Executed Pass / Fail (Running Total for Test Audit Trail.)"
  $summary_results.puts "<br>Test Count = " + $test_count1.to_s 
  $summary_results.puts "<br>Test Pass Count = " + $test_pass_count.to_s 
  $summary_results.puts "<br>Test Failed Count = " + $test_failed_count.to_s 
  $results.puts "<br>End MT4 Negative Form Test 51 char Last Name, Country = " + $country 
  $summary_results.puts "<br>******* End CI 51 char Last Name Test. ***************************"
end

def ci_one_char_first_name
# This is a negative test for the CI Demo form
  $test_count = $test_count + 1
  $test_count1 = $test_count 
  $results.puts "<br>Starting CI one char invalid format Test."
  setup_negative_test
  site_connect_ci
  accept_cookie_policy
  get_server_name
  ci_validate_title_demo_signup
  $results.puts "<br>51 char invalid format test, brand = " + $brand 
  ci_populate_form_first_name_one_char
  ci_populate_form_last_name
  ci_populate_form_email
  ci_populate_form_phone_number
  ci_negative_demo_form_submit
  ci_negative_validate_confirm_page
  $results.puts "<br>***** CI one char First Name Test Completed, Status:" 
  $results.puts "<br>Total Test Executed Pass / Fail (Running Total for Test Audit Trail.)"
  $results.puts "<br>Test Count = " + $test_count1.to_s 
  $results.puts "<br>Test Pass Count = " + $test_pass_count.to_s 
  $results.puts "<br>Test Failed Count = " + $test_failed_count.to_s 
  $summary_results.puts "<br>***** CI one char First Name Test Completed, Status:"
  $summary_results.puts "<br>Total Test Executed Pass / Fail (Running Total for Test Audit Trail.)"
  $summary_results.puts "<br>Test Count = " + $test_count1.to_s 
  $summary_results.puts "<br>Test Pass Count = " + $test_pass_count.to_s 
  $summary_results.puts "<br>Test Failed Count = " + $test_failed_count.to_s 
  $results.puts "<br>End CI Negative Form Test one char First Name, Country = " + $country 
  $summary_results.puts "<br>******* End CI one char First Name Test. ***************************"
 end

def ci_one_char_last_name
# This is a negative test for the CI Demo form
  $test_count = $test_count + 1
  $test_count1 = $test_count 
  $results.puts "<br>Starting CI Last Name with numbers Test."
  setup_negative_test
  site_connect_ci
  accept_cookie_policy
  get_server_name
  ci_validate_title_demo_signup
  $results.puts "<br>last name with 51 char test, brand = " + $brand 
  ci_populate_form_first_name
  ci_populate_form_last_name_one_char
  ci_populate_form_email
  ci_populate_form_phone_number 
  ci_negative_demo_form_submit
  ci_negative_validate_confirm_page
  $results.puts "<br>***** CI4 one char Last Name Test Completed, Status:" 
  $results.puts "<br>Total Test Executed Pass / Fail (Running Total for Test Audit Trail.)"
  $results.puts "<br>Test Count = " + $test_count1.to_s 
  $results.puts "<br>Test Pass Count = " + $test_pass_count.to_s 
  $results.puts "<br>Test Failed Count = " + $test_failed_count.to_s 
  $summary_results.puts "<br>***** CI one char Last Name Test Completed, Status:"
  $summary_results.puts "<br>Total Test Executed Pass / Fail (Running Total for Test Audit Trail.)"
  $summary_results.puts "<br>Test Count = " + $test_count1.to_s  
  $summary_results.puts "<br>Test Pass Count = " + $test_pass_count.to_s 
  $summary_results.puts "<br>Test Failed Count = " + $test_failed_count.to_s 
  $results.puts "<br>End CI Negative Form Test one char Last Name, Country = " + $country 
  $summary_results.puts "<br>******* End CI one char Last Name Test. ****************************"
end

# ******************* Brand Code for log file **********************************************

def before_country_test_print_mt4
  $results.puts "<br>***** Starting Demo Account MT4 Test: Country = " + $country 
  $summary_results.puts "<br>***** Starting Demo Account MT4 Test: Country = " + $country 
end

def after_country_test_print_mt4
  $results.puts "<br>***** Demo Account MT4 Test Status: Country = " + $country 
  $results.puts "<br>Test Count = " + $test_count1.to_s 
  $results.puts "<br>Test Pass Count = " + $test_pass_count.to_s  
  $results.puts "<br>Test Failed Count = " + $test_failed_count.to_s 
  $summary_results.puts "<br>***** Demo Account MT4 Test Status: Country = " + $country 
  $summary_results.puts "<br>Test Count = " + $test_count1.to_s  
  $summary_results.puts "<br>Test Pass Count = " + $test_pass_count.to_s 
  $summary_results.puts "<br>Test Failed Count = " + $test_failed_count.to_s 
  $results.puts "<br>End Demo Form Test for Country = " + $country 
end

def before_country_test_print_ci
  $results.puts "<br>***** Starting Demo Account CI Test: Country = " + $country 
  $summary_results.puts "<br>***** Starting Demo Account CI Test: Country = " + $country 
end

def after_country_test_print_ci
  $results.puts "<br>***** Demo Account CI Test Status: Country = " + $country 
  $results.puts "<br>Test Count = " + $test_count1.to_s  
  $results.puts "<br>Test Pass Count = " + $test_pass_count.to_s 
  $results.puts "<br>Test Failed Count = " + $test_failed_count.to_s 
  $summary_results.puts "<br>***** Demo Account CI Test Status: Country = " + $country 
  $summary_results.puts "<br>Test Count = " + $test_count1.to_s 
  $summary_results.puts "<br>Test Pass Count = " + $test_pass_count.to_s 
  $summary_results.puts "<br>Test Failed Count = " + $test_failed_count.to_s 
  $results.puts "<br>End Demo Form Test for Country = " + $country 
end

def ci_negative_test_suite		# Error Test count
  ci_missing_first_name         # 1. 
  ci_missing_last_name          # 2. 
  ci_missing_email              # 3.    
  ci_missing_phone_number	    # 4. 
  ci_first_name_with_numbers    # 5. 
  ci_last_name_with_numbers     # 6.
  ci_email_invalid_format       # 7.
  ci_phone_invalid_format       # 8. 
  ci_51_char_first_name         # 9. 
  ci_51_char_last_name          # 10. 
  ci_one_char_first_name        # 11. 
  ci_one_char_last_name         # 12.
end

def mt_negative_test_suite		# Error Test count
  mt_missing_first_name         # 1.
  mt_missing_last_name          # 2.
  mt_missing_email              # 3.
  mt_missing_phone_number       # 4.
  mt_first_name_with_numbers    # 5. 
  mt_last_name_with_numbers     # 6.
  mt_email_invalid_format       # 7.
  mt_phone_invalid_format       # 8. 
  mt_51_char_first_name         # 9. 
  mt_51_char_last_name          # 10. 
  mt_one_char_first_name        # 11. 
  mt_one_char_last_name         # 12.
end

# ******************* Start of Testing ******************************************************
setup_firefox
get_country_config
# Iterate over the strings with "each." Positive Test per country.
$countrys.each do |st|
				   $country = st
				   $test_count = $test_count + 1
				   $test_count1 = $test_count
				        case $brand
				        when "mt4"
						   before_country_test_print_mt4
						   mt4_form_demo_test
						   after_country_test_print_mt4
				        when "ci"
						   before_country_test_print_ci
					       ci_form_demo_test
						   after_country_test_print_ci
					    else
					        puts "This test requires a brand"
				      end
			   end	
# ***** Negative tests per brand only the configured brands tests will execute (MT4 or CI) *****
	case $brand  # brand = mt4 or ci
		when "ci" 
		     ci_negative_test_suite			# Executes 12 negative tests
	    when "mt4" 
        	 mt_negative_test_suite			# Executes 12 negative tests
		else
			 $results.puts "<br>Error! Negative test Failed to execute!" 
	end
tear_down
# ****************** End of Testing **************************************************
exit

			
