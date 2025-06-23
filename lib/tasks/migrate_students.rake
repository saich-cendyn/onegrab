namespace :migrate do
  desc "Migrate users with role 'student' into students table"
  task students: :environment do
    User.where(role: 'student').find_each do |user|
      Student.create!(
          user_id: user.id,
          name: user.full_name,
          email: user.email,
          phone: user.phone,
          dob: Date.yesterday,
          gender: 'male',
          status: 'active',
          progress_status: 'not_started'
      )
      puts "Migrated user #{user.id} to student"
    end
    puts "Migration complete!"
  end
end
