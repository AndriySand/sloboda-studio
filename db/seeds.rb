User.create(name: 'Some one', email: 'admin@example.com', password: 'password')

10.times do |i|
  User.create(name: Faker::Name.name, email: Faker::Internet.email, password: 'password')
end
GENRES = %w(Fiction Comedy Drama Horror Non-fiction Realistic Romantic Satire Tragedy Tragicomedy Fantasy Mythology)

GENRES.each { |genre| Genre.create(name: genre) }

STATUSES = %w(published draft unpublished editing)

User.all.each do |user|
  10.times do |i|
    book = Book.new(title: Faker::Lorem.sentence, author_id: user.id, content: Faker::Lorem.paragraph(50), status: STATUSES.sample,
     description: Faker::Lorem.paragraph(10), created_at: DateTime.now - (i * 36).hours )
    Genre.all.sample(rand(0..12)).each do |genre|
      book.genres << genre
    end
    book.save
  end
end
