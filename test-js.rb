require 'rspec'
require 'rubygems'
require 'watir'
require 'net/smtp'
require 'mail'
require 'fileutils'

def chrome_setup
@browser = Watir::Browser.new
  rescue
    puts ">---------- Chrome Browser Setup Error! ----------<"
	  else 
	    puts "******* Chrome Setup Successfully! *******"
end

def connect
@browser.goto $site
sleep 5
#get_server_name
  rescue
    puts "---------- Browser Connection Error! ----------"
	tear_down
	  else 
	    puts "******* Java Script Errors Below for the Request! *******"
end

def get_url_list_config
  # gets url list from flat file.
  @url_list = [] # Array.new empty
  @url_list = File.open("ci-uk-url-list.config") or die "Unable to open url list configuration file..."
end

def create_js_errors_logfile
   get_unique_number
   x  = "/inetpub/wwwroot/AutoTestResults/JS-page-errors/"
   y = "js-errors-ci-uk-"+$unique_number+".htm"
   log_file_create = File.new("#{x}#{y}", "w")
   @results = File.new("#{x}#{y}", "a")
   @results.puts "<br>***** Starting the Java Script Error logs, Let the Fun Begin! *****"
   	rescue
      puts "***** Not Able to Create Java Script Error Log File! = " 
	  else
		puts "***** Log File Created Successfully! *****"
end

def js_errors_logfile_close
  @results.close
  	rescue
	  @results.puts "<br>***** Unable to Close log file! *****"
		else
		  puts "***** Successfully Closed log file! *****"
end		

def print_js_errors
  log = @browser.driver.manage.logs.get(:browser)
  errors = log.select{ |entry| entry.level.eql? 'SEVERE' }
  if errors.count > 0
    errors_count1 = errors.count
	puts "Total Number of Errors for this Request = " + errors_count1.to_s 
	puts "Test Request = " + $site 
	puts errors
	@results.puts "<br>Test Request = " + $site +"<br/>"
	@results.puts errors
	@test_failed_count = @test_failed_count + 1
		puts "@test_failed_count: "
		puts @test_failed_count
  end # else
    if  errors.count == 0
		puts "Total Number of JS Errors for this Request = 0"
		@test_pass_count = @test_pass_count + 1
		puts "@test_pass_count: "
		puts @test_pass_count
	end
        rescue
	      puts "The Java Script Error Test has Failed!"
	      @browser.quit
		    else
			  puts "******* End Test Request Logging *******"
end 
  
def tear_down
  @browser.quit
  js_errors_logfile_close
  sleep 1
  # mail_test_results
  exit
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
	    puts "get_unique number failed"
  		   else
		     puts "Successfully created a unique "
end

def get_server_name
  server_name = $browser.element(:xpath,"//*[contains(@id, 'DebugInfo')]").value
  rescue
    @results.puts "<br>unable to find server name!"
       else	
	     @results.puts "<br>Server Name = " + server_name +"<br/>"
end

def setup_test
  create_js_errors_logfile
  get_url_list_config
  chrome_setup
  @test_count = 0
  @test_pass_count = 0
  @test_failed_count = 0
 end

def mail_test_results
  options = { :address              => "smtp.gmail.com",
              :port                 => 587,
              :user_name            => 'davidp.gain@gmail.com',
              :password             => 'magic777',
              :authentication       => 'plain',
			  :enable_starttls_auto => true  }

  Mail.defaults do           
    delivery_method :smtp, options
  end
       		 
  Mail.deliver do            
       to 		'david.palumbo@gaincapital.com, davidp.gain@gmail.com '
       from 	'davidp.gain@gmail.com'
       subject 	'Automated Test Results'
	   body     'Please see the Attached file for test results!'
	   add_file 'js_errors.log'
				 
   end
end
		
setup_test
@url_list.each do |st|
				 $site = st
				 @test_count = @test_count + 1
				 puts "************** Java Script Error Scan for the Below Request *********************"
				 puts st
				 @test_count1 = @test_count
				 puts "Test count = " +  @test_count1.to_s 
				 connect
				 print_js_errors
				 $number_failed = @test_failed_count
				 $number_passed = @test_pass_count
			   end
				 @results.puts "<br>Total Number of Executed Tests = " + @test_count1.to_s + "<br/>"
				 @results.puts "<br>Passed Tests = " + $number_passed.to_s  
				 @results.puts "<br>Failed Tests = " + $number_failed.to_s 
			     @results.puts "<br>******* End Java Script Error Logging Test! ***********"
				 puts ""
				 puts "Total Number of Executed Tests = " + @test_count1.to_s 
				 puts "Passed Tests = " + $number_passed.to_s  
				 puts "Failed Tests = " + $number_failed.to_s 
			     puts "******* End Java Script Error Logging Test! ***********"
tear_down
