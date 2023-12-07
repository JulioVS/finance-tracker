class CreateFriendships < ActiveRecord::Migration[7.0]
  def change
    create_table :friendships do |t|
      t.references :user, null: false, foreign_key: true

      # Agrego una 'autoreferencia' a la propia 'users' pero llamada "friend"
      # Es decir en cada registro el usuario "user" será amigo del (tambien) usuario "friend"
      # Es una relación "n a n" del model "User" con si mismo.-
      t.references :friend, references: :users, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
