require_relative '../models/address_book.rb'

RSpec.describe AddressBook do

  let(:book) { AddressBook.new }

  # Helpers

  def check_entry(entry, expected_name, expected_number, expected_email)
    expect(entry.name).to eql expected_name
    expect(entry.phone_number).to eql expected_number
    expect(entry.email).to eql expected_email
  end

  def check_csv_entry_count(csv_file_name, expected_entry_count)
    book.import_from_csv(csv_file_name)

    # Did we correctly read in the correct number of entries?
    expect(book.entries.size).to eq(expected_entry_count)
  end

  def check_csv_entry_number(csv_file_name, entry_index, name, phone, email)
    book.import_from_csv(csv_file_name)
    entry_one = book.entries[entry_index]

    check_entry(entry_one, name, phone, email)
  end

  # Tests

  context "attributes" do

    it "should respond to entries" do
      expect(book).to respond_to(:entries)
    end

    it "should initialize entries as an array" do
      expect(book.entries).to be_a(Array)
    end

     it "should initialize entries as empty" do
      expect(book.entries.size).to eq(0)
    end

  end # attributes

  context '.add_entry' do

    it "adds only one entry to the address book" do
      book.add_entry('Ada Lovelace', '010.012.1815', 'augusta.king@lovelace.com')

      expect(book.entries.size).to eq(1)
    end

    it "adds the correct info to entries" do
      book.add_entry('Ada Lovelace', '010.012.1815', 'augusta.king@lovelace.com')
      new_entry = book.entries.first

      expect(new_entry.name).to eq('Ada Lovelace')
      expect(new_entry.email).to eq('augusta.king@lovelace.com')
      expect(new_entry.phone_number).to eq('010.012.1815')
    end

  end # .add_entry

  context ".remove_entry" do

    it "removes one existing entry" do
      book.add_entry('Ada Lovelace', '010.012.1815', 'augusta.king@lovelace.com')
      num_entries = book.entries.size

      book.remove_entry(book.entries.first)

      expect(book.entries.size).to eq(num_entries - 1)
    end

    it "returns the deleted entry" do
      book.add_entry('Ada Lovelace', '010.012.1815', 'augusta.king@lovelace.com')
      entry = book.entries.first

      removed_entry = book.remove_entry(book.entries.first)

      expect(entry).to eq(removed_entry)
    end

  end # .remove_entry

  context '.import_from_csv' do

    context 'entries.csv' do

      it "imports the correct number of entires" do
        check_csv_entry_count("entries.csv",  5)
      end

      it "imports the 1st entry" do
        check_csv_entry_number("entries.csv",  0, "Bill", "555-555-4854", "bill@blocmail.com")
      end

      it "imports the 2nd entry" do
        check_csv_entry_number("entries.csv",  1, "Bob", "555-555-5415",  "bob@blocmail.com")
      end

      it "imports the 3rd entry" do
        check_csv_entry_number("entries.csv",  2, "Joe", "555-555-3660", "joe@blocmail.com")
      end

      it "imports the 4th entry" do
        check_csv_entry_number("entries.csv",  3, "Sally", "555-555-4646", "sally@blocmail.com")
      end

      it "imports the 5th entry" do
        check_csv_entry_number("entries.csv",  4, "Sussie", "555-555-2036", "sussie@blocmail.com")
      end

    end # entries.csv

    context 'entries2.csv' do

      it "imports the correct number of entires" do
        check_csv_entry_count("entries2.csv",  3)
      end

      it "imports the 1st entry" do
        check_csv_entry_number("entries2.csv",  0, "Bonnie", "555-555-3660", "bonnie@blocmail.com")
      end

      it "imports the 2nd entry" do
        check_csv_entry_number("entries2.csv",  1, "Joe", "555-555-4854", "joe@blocmail.com")
      end

      it "imports the 3rd entry" do
        check_csv_entry_number("entries2.csv",  2, "Reed", "555-555-5415", "reed@blocmail.com")
      end

    end # entries.csv

    context ".binary_search" do

      it "searches AddressBook for a non-existent entry" do
        book.import_from_csv("entries.csv")
        entry = book.binary_search("Dan")

        expect(entry).to be_nil
      end 

      it "searches AddressBook for Bill" do
        book.import_from_csv("entries.csv")
        entry = book.binary_search("Bill")
        expect entry.instance_of?(Entry)

        check_entry(entry, "Bill", "555-555-4854", "bill@blocmail.com")
      end

      it "searches AddressBook for Bob" do
       book.import_from_csv("entries.csv")
       entry = book.binary_search("Bob")

       expect entry.instance_of?(Entry)
       check_entry(entry, "Bob", "555-555-5415", "bob@blocmail.com")
     end 
 
     it "searches AddressBook for Joe" do
       book.import_from_csv("entries.csv")
       entry = book.binary_search("Joe")

       expect entry.instance_of?(Entry)
       check_entry(entry, "Joe", "555-555-3660", "joe@blocmail.com")
     end 
 
     it "searches AddressBook for Sally" do
       book.import_from_csv("entries.csv")
       entry = book.binary_search("Sally")

       expect entry.instance_of?(Entry)
       check_entry(entry, "Sally", "555-555-4646", "sally@blocmail.com")
     end 
 
     it "searches AddressBook for Sussie" do
       book.import_from_csv("entries.csv")
       entry = book.binary_search("Sussie")

       expect entry.instance_of?(Entry)
       check_entry(entry, "Sussie", "555-555-2036", "sussie@blocmail.com")
     end

     it "searches AddressBook for Billy - non-existent" do
       book.import_from_csv("entries.csv")

       entry = book.binary_search("Billy")
       expect(entry).to be_nil
     end

   end # .binary_search

   context ".iterative_search" do

    it "searches AddressBook for a non-existent entry" do
      book.import_from_csv("entries.csv")
      entry = book.iterative_search("Dan")

      expect(entry).to be_nil
    end 

    it "searches AddressBook for Bill" do
      book.import_from_csv("entries.csv")
      entry = book.iterative_search("Bill")

      expect entry.instance_of?(Entry)
      check_entry(entry, "Bill", "555-555-4854", "bill@blocmail.com")
    end

    it "searches AddressBook for Bob" do
      book.import_from_csv("entries.csv")
      entry = book.iterative_search("Bob")

      expect entry.instance_of?(Entry)
      check_entry(entry, "Bob", "555-555-5415", "bob@blocmail.com")
    end 

    it "searches AddressBook for Joe" do
      book.import_from_csv("entries.csv")
      entry = book.iterative_search("Joe")

      expect entry.instance_of?(Entry)
      check_entry(entry, "Joe", "555-555-3660", "joe@blocmail.com")
    end 

    it "searches AddressBook for Sally" do
      book.import_from_csv("entries.csv")
      entry = book.iterative_search("Sally")

      expect entry.instance_of?(Entry)
      check_entry(entry, "Sally", "555-555-4646", "sally@blocmail.com")
    end 

    it "searches AddressBook for Sussie" do
      book.import_from_csv("entries.csv")
      entry = book.iterative_search("Sussie")

      expect entry.instance_of?(Entry)
      check_entry(entry, "Sussie", "555-555-2036", "sussie@blocmail.com")
    end

    it "searches AddressBook for Billy - non-existent" do
      book.import_from_csv("entries.csv")
      entry = book.iterative_search("Billy")
      expect(entry).to be_nil
    end

   end # .iterative_search
    
  end # .import_from_csv

  context ".delete_all_entires" do

    it "should work when there are no entries" do
      book.delete_all_entries
      expect(book.entries.size).to eql(0)
    end

    it "should work when there are multiple entries" do
      book.import_from_csv("entries.csv")
      expect(book.entries.count).to be > 0
      
      book.delete_all_entries
      expect(book.entries.size).to eql(0)
    end

  end # .delete_all_entries

end