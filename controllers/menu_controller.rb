require_relative '../models/address_book'

class MenuController
  attr_accessor :address_book

  def initialize
    @address_book = AddressBook.new

    # each menu item's number, text, and associated method
    @menu_data = [ { num: 1, text: "View all entries",    method: :view_all_entries   },
                   { num: 2, text: "View entry #",        method: :view_entry_number  },
                   { num: 3, text: "Create an entry",     method: :create_entry       },
                   { num: 4, text: "Search for an entry", method: :search_entries     },
                   { num: 5, text: "Import from a CSV",   method: :read_csv           },
                   { num: 6, text: "Delete all entries",  method: :delete_all_entires },
                   { num: 7, text: "Exit",                method: :exit } ]

  end

  def main_menu
    puts "Main Menu - #{address_book.entries.count} entries"

    # display available options
    @menu_data.each do |option|
      puts "#{option[:num]} - #{option[:text]}"
    end

    print "Enter your selection: "

    selection = gets.to_i
    puts ""

    process_input(selection)
  end

  def search_submenu(entry)
    puts "\nd - delete entry"
    puts "e - edit this entry"
    puts "m - return to main menu"

    selection = gets.chomp
    case selection
    when "d"
      system "clear"
      delete_entry(entry)
      main_menu

    when "e"
      edit_entry(entry)
      system "clear"
      main_menu

    when "m"
      system "clear"
      main_menu
      
    else
      system "clear"
      puts "#{selection} is not a valid input"
      puts entry.to_s
      search_submenu(entry)
     end
   end

  def view_all_entries
    if address_book.entries.count > 0
      address_book.entries.each do |entry|
        system "clear"
        puts entry.to_s

        entry_submenu(entry)    
      end
    else
      puts "No entries to view"
    end
  end

  def view_entry_number
    cnt = address_book.entries.count
    if cnt > 0
      print "Entry to view (1 - #{cnt}): "
      selection = gets.to_i
      if (1..cnt).include?(selection)
        puts address_book.entries[selection - 1].to_s
      else
        puts "Invalid selction."
      end
    else
      puts "No entries to view"
    end
  end
 
  def create_entry
    system "clear"
    puts "New AddressBloc Entry"
 
     print "Name: "
     name = gets.chomp
     print "Phone number: "
     phone = gets.chomp
     print "Email: "
     email = gets.chomp

     @address_book.add_entry(name, phone, email)
 
     system "clear"
     puts "New entry created"
  end

  def delete_entry(entry)
    address_book.entries.delete(entry)
    puts "#{entry.name} has been deleted"
  end

  def delete_all_entires
    if address_book.entries.count == 0
      puts "There are no entries to delete"
    else
      print "Are you SURE you want to delete entries? (y/N): "
      answer = gets.chomp
  
      if answer == 'y'
        # I'd rather use: 
        #  address_book.delete_all_entires

        # My assumption is that I can't modify (delete elements) an array
        # while enumerating that collection.
        entries = address_book.entries.dup
        for entry in entries 
          delete_entry(entry)
        end        
      end
    end
  end

  def edit_entry(entry)
    print "Updated name: "
    name = gets.chomp
    print "Updated phone number: "
    phone_number = gets.chomp
    print "Updated email: "
    email = gets.chomp
 
    entry.name = name if !name.empty?
    entry.phone_number = phone_number if !phone_number.empty?
    entry.email = email if !email.empty?

    system "clear"
    puts "Updated entry:"
    puts entry
   end
 
  def search_entries
    print "Search by name: "
    name = gets.chomp

    match = address_book.binary_search(name)
    system "clear"

    if match
      puts match.to_s
      search_submenu(match)
    else
      puts "No match found for #{name}"
    end
  end
 
  def read_csv
    print "Enter CSV file to import: "
    file_name = gets.chomp
 
    if file_name.empty?
     system "clear"
     puts "No CSV file read"
     main_menu
    end

    begin
     entry_count = @address_book.import_from_csv(file_name)
     system "clear"
     puts "#{entry_count} new entries added from #{file_name}"
    rescue
     puts "#{file_name} is not a valid CSV file, please enter the name of a valid CSV file"
     read_csv
    end
  end  

  def exit
    puts "Good-bye!"
    exit!(true)
  end

private

  # returns nil if input_num is invalid, index into @menu_data otherwise
  def index_for_input(input_num)
    @menu_data.index { |item| item[:num] == input_num }
  end

  def process_input(input_num)
    index = index_for_input(input_num)

    if !index
      puts "Sorry, that is not a valid input"
    else
      method = @menu_data[index][:method]
      self.send(method)
    end

    main_menu
  end

  def entry_submenu(entry)
    puts "n - next entry"
    puts "d - delete entry"
    puts "e - edit this entry"
    puts "m - return to main menu"
 
    selection = gets.chomp
    case selection

    when "n"

    when "d"
      delete_entry(entry)

    when "e"
      edit_entry(entry)
      entry_submenu(entry)

    when "m"
      system "clear"
      main_menu
    else
      system "clear"
      puts "#{selection} is not a valid input"
      entries_submenu(entry)
    end
  end  

end