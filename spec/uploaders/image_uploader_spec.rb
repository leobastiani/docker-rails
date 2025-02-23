require 'rails_helper'

describe ImageUploader do
  let(:post) { create :post }
  let(:clip) { create :clip, post: post }

  before { clip.reload }

  it 'generates image versions' do
    expect(clip.image.keys).to match_array([:original, :large, :thumbnail])
  end

  it 'stores image' do
    expect(clip.image[:original].storage_key).to eq('store')
    expect(clip.image[:large].storage_key).to eq('store')
    expect(clip.image[:thumbnail].storage_key).to eq('store')
  end

  describe "metadata" do
    subject { clip.image[:original] }

    it 'extracts mime type' do
      expect(subject.mime_type).to eq('image/jpeg')
    end

    it "extracts filesize" do
      expect(subject.size).to eq(8826)
    end

    it "extracts original filename" do
      expect(subject.original_filename).to eq('example.jpg')
    end

    it "extracts extension" do
      expect(subject.extension).to eq('jpg')
    end
  end

  it 'rejects other files than images' do
    clip = post.clips.build image: fixture_file_upload('spec/fixtures/example.txt')

    clip.valid?
    expect(clip.errors[:image]).to eq ['type must be one of: image/jpeg, image/png, image/gif']
  end
end
