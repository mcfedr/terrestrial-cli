require 'spec_helper'

describe Terrestrial::Cli::DotStringsParser do

  def make_aborts_raise!
    allow(Kernel).to receive(:abort).and_raise(RuntimeError.new("Parser aborted prematurely"))
  end

  before(:each) do
    make_aborts_raise!
  end

  it "parses an Localizable.strings file format for strings and identifiers" do
    file = "spec/fixtures/ExampleLocalizable.strings"

    results = Terrestrial::Cli::DotStringsParser.parse_file(file)

    expect(results.count).to eq 6

    first = results[0]
    expect(first["string"]).to eq "nom d'utilisateur"
    expect(first["identifier"]).to eq "Username"
    expect(first["type"]).to eq "localizable.strings"
    expect(first["context"]).to eq "No comment provided by engineer."
    expect(first["file"]).to eq "spec/fixtures/ExampleLocalizable.strings"

    second = results[1]
    expect(second["string"]).to eq "profil de %1$@"
    expect(second["identifier"]).to eq "Main_Profile"
    expect(second["type"]).to eq "localizable.strings"
    expect(second["context"]).to eq nil
    expect(second["file"]).to eq "spec/fixtures/ExampleLocalizable.strings"

    third = results[2]
    expect(third["string"]).to eq "Hello %@,\n\nCheck out %@.\n\nSincerely,\n\n%@"
    expect(third["identifier"]).to eq "multiline"
    expect(third["type"]).to eq "localizable.strings"
    expect(third["context"]).to eq nil
    expect(third["file"]).to eq "spec/fixtures/ExampleLocalizable.strings"

    fourth = results[3]
    expect(fourth["string"]).to eq "Hello %@,\nyou"
    expect(fourth["identifier"]).to eq "multiline_comment"
    expect(fourth["type"]).to eq "localizable.strings"
    expect(fourth["context"]).to eq "this is a\n multiline\n comment"
    expect(fourth["file"]).to eq "spec/fixtures/ExampleLocalizable.strings"

    fifth = results[4]
    expect(fifth["string"]).to eq "https://www.mah.url"
    expect(fifth["identifier"]).to eq "MAH_URL"
    expect(fifth["type"]).to eq "localizable.strings"
    expect(fifth["context"]).to eq nil
    expect(fifth["file"]).to eq "spec/fixtures/ExampleLocalizable.strings"

    sixth = results[5]
    expect(sixth["string"]).to eq 'Look at \"how\" escaped I am.'
    expect(sixth["identifier"]).to eq "has_escaped_quote"
    expect(sixth["type"]).to eq "localizable.strings"
    expect(sixth["context"]).to eq nil
    expect(sixth["file"]).to eq "spec/fixtures/ExampleLocalizable.strings"
  end

  it "can handle UTF-16 encoded files" do
    # genstrings encodes all strings in UTF-16
    file = "spec/fixtures/UTF_16_Localizable.strings"

    results = Terrestrial::Cli::DotStringsParser.parse_file(file)
    expect(results.count).to eq 1


    first = results[0]
    expect(first["string"]).to eq "Choose Audio Track"
    expect(first["identifier"]).to eq "CHOOSE_AUDIO_TRACK"
    expect(first["type"]).to eq "localizable.strings"
    expect(first["context"]).to eq nil
    expect(first["file"]).to eq "spec/fixtures/UTF_16_Localizable.strings"
  end

  it "ignores double slash comments" do
    file = "spec/fixtures/ExampleWithCommentsLocalizable.strings"

    results = Terrestrial::Cli::DotStringsParser.parse_file(file)
    expect(results.count).to eq 4
    
    first = results[0]
    expect(first["string"]).to eq "%d Failed Passcode Attempts"
    expect(first["identifier"]).to eq "PASSCODE_FAILED_FORMAT"
    expect(first["type"]).to eq "localizable.strings"
    expect(first["context"]).to eq nil
    expect(first["file"]).to eq "spec/fixtures/ExampleWithCommentsLocalizable.strings"

    second = results[1]
    expect(second["string"]).to eq "Settings"
    expect(second["identifier"]).to eq "Settings"
    expect(second["type"]).to eq "localizable.strings"
    expect(second["context"]).to eq nil
    expect(second["file"]).to eq "spec/fixtures/ExampleWithCommentsLocalizable.strings"

    third = results[2]
    expect(third["string"]).to eq "Empty Media Library"
    expect(third["identifier"]).to eq "EMPTY_LIBRARY"
    expect(third["type"]).to eq "localizable.strings"
    expect(third["context"]).to eq "Comment for the Engineer!"
    expect(third["file"]).to eq "spec/fixtures/ExampleWithCommentsLocalizable.strings"

    fourth = results[3]
    expect(fourth["string"]).to eq "For playback\ndo not panick"
    expect(fourth["identifier"]).to eq "EMPTY_LIBRARY_LONG"
    expect(fourth["type"]).to eq "localizable.strings"
    expect(fourth["context"]).to eq nil
    expect(fourth["file"]).to eq "spec/fixtures/ExampleWithCommentsLocalizable.strings"
  end
end
