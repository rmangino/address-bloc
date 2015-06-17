require_relative '../models/address_book.rb'

RSpec.describe AddressBook do

  context "attributes" do

    it "should respond to entries" do
      book = AddressBook.new

      expect(book).to respond_to(:entries)
    end

    it "should initialize entries as an array" do
      book = AddressBook.new

      expect(book.entries).to be_a(Array)
    end

     it "should initialize entries as empty" do
      book = AddressBook.new

      expect(book.entries.size).to eq(0)
    end

  end # attributes

  context '.add_entry' do

    it "adds only one entry to the address book" do
      book = AddressBook.new
      book.add_entry('Ada Lovelace', '010.012.1815', 'augusta.king@lovelace.com')

      expect(book.entries.size).to eq(1)
    end

    it "adds the correct info to entries" do
      book = AddressBook.new     
      book.add_entry('Ada Lovelace', '010.012.1815', 'augusta.king@lovelace.com')
      new_entry = book.entries.first

      expect(new_entry.name).to eq('Ada Lovelace')
      expect(new_entry.email).to eq('augusta.king@lovelace.com')
      expect(new_entry.phone_number).to eq('010.012.1815')
    end

  end # .add_entry

  context ".remove_entry" do

    it "removes one existing entry" do
      book = AddressBook.new     
      book.add_entry('Ada Lovelace', '010.012.1815', 'augusta.king@lovelace.com')
      num_entries = book.entries.size

      book.remove_entry(book.entries.first)

      expect(book.entries.size).to eq(num_entries - 1)
    end

    it "returns the deleted entry" do
      book = AddressBook.new     
      book.add_entry('Ada Lovelace', '010.012.1815', 'augusta.king@lovelace.com')
      entry = book.entries.first

      removed_entry = book.remove_entry(book.entries.first)

      expect(entry).to eq(removed_entry)
    end

  end # .remove_entry

end