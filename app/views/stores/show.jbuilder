json.partial! 'item', store: store, store_photos: store_photos
json.opening_hours opening_hours
json.reviews reviews
json.is_open_now is_open_now
json.close_time open_period && open_period.close_time
json.review_report review_report
json.is_hide is_hide
json.is_review is_review
json.is_bookmark is_bookmark
json.tags tags
json.recommend_yes store.reviews.filter { |r| r.recommend == 'yes' }.count
json.recommend_no store.reviews.filter { |r| r.recommend == 'no' }.count
