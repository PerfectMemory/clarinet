describe Clarinet::Model do

  before :each do
    app = Clarinet::App.new 'fake_api_key'
    @model = app.models.init_model Clarinet::Model::GENERAL
  end

  describe '#predict' do
    context 'when analyzing an image' do
      it 'should call /outputs endpoint with correct payload given single url' do
        req_stub = stub_request(:post, "https://api.clarifai.com/v2/models/#{Clarinet::Model::GENERAL}/outputs")
          .with(body: {
            inputs: [
              {
                data: {
                  image: {
                    url: 'https://samples.clarifai.com/metro-north.jpg'
                  }
                }
              }
            ]
          })
          .to_return(fixture_file('model-predict-default'))

        @model.predict 'https://samples.clarifai.com/metro-north.jpg'

        expect(req_stub).to have_been_requested
      end

      it 'should call API endpoint with correct payload given multiple urls' do
        req_stub = stub_request(:post, "https://api.clarifai.com/v2/models/#{Clarinet::Model::GENERAL}/outputs")
          .with(body: {
            inputs: [
              {
                data: {
                  image: {
                    url: 'https://samples.clarifai.com/metro-north.jpg'
                  }
                }
              },
              {
                data: {
                  image: {
                    url: 'https://samples.clarifai.com/metro-north-2.jpg'
                  }
                }
              }
            ]
          })
          .to_return(fixture_file('model-predict-default'))

        @model.predict ['https://samples.clarifai.com/metro-north.jpg', 'https://samples.clarifai.com/metro-north-2.jpg']

        expect(req_stub).to have_been_requested
      end
    end

    context 'when analyzing a video' do
      it 'should call /outputs endpoint with correct payload given single url' do
        req_stub = stub_request(:post, "https://api.clarifai.com/v2/models/#{Clarinet::Model::GENERAL}/outputs")
          .with(body: {
            inputs: [
              {
                data: {
                  video: {
                    url: 'http://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_30mb.mp4'
                  }
                }
              }
            ]
          })
          .to_return(fixture_file('model-predict-default'))

        @model.predict 'http://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_30mb.mp4', video: true

        expect(req_stub).to have_been_requested
      end

      it 'should call API endpoint with correct payload given multiple urls' do
        req_stub = stub_request(:post, "https://api.clarifai.com/v2/models/#{Clarinet::Model::GENERAL}/outputs")
          .with(body: {
            inputs: [
              {
                data: {
                  video: {
                    url: 'http://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_30mb.mp4'
                  }
                }
              },
              {
                data: {
                  video: {
                    url: 'http://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_20mb.mp4'
                  }
                }
              }
            ]
          })
          .to_return(fixture_file('model-predict-default'))

        @model.predict [
          'http://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_30mb.mp4',
          'http://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_20mb.mp4'
        ], video: true

        expect(req_stub).to have_been_requested
      end
    end
  end

end
