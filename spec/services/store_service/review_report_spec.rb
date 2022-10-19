require 'rails_helper'

describe StoreService::ReviewReport do
  let!(:users) { create_list :user, 5 }
  let!(:store) { create :store}
  let!(:tags) { create_list :tag, 5 }
  let(:params) { { store_id: store.id } }
  let(:service) { described_class.new(**params) }

  def create_review(user, recommend, tags=[])
    review = create :review, {
      user: user,
      store: store,
      recommend: recommend,
    }
    tags.each do |tag|
      create :store_review_tag, store: store, review: review, tag: tag
    end

    review
  end

  before do
    create_review(users[0], 'yes', [tags[0], tags[1]])
    create_review(users[1], 'no')
    create_review(users[2], 'yes', [tags[0], tags[4]])
    create_review(users[3], 'normal')
    create_review(users[4], 'yes')
  end

  it 'takes required attributes to initialize' do
    described_class.new(store_id: 1)
  end

  it 'return report' do
    res = service.perform

    expect_res = {
      recommend: {
        no: 1,
        normal: 1,
        yes: 3
      },
      primary_tags: [],
      secondary_tags: [
        {
          primary: false,
          name: tags[0].name,
          count: 2
        },
        {
          primary: false,
          name: tags[1].name,
          count: 1
        },
        {
          primary: false,
          name: tags[4].name,
          count: 1
        }
      ]
    }
    expect(res).to eq(expect_res)
  end
end
