require 'json'
class Factory
  def self.create_user(arr)
    usr = {
      "uid": arr[0],
      "duns": arr[1]
    }
    if arr[2]
      puts type(arr[2])
      usr.merge(arr[2])
    end
    return usr
  end

  def self.add_key(user_array, extrakeys)
    new_arr = Array.new
    user_array.each_with_index do |u, i|
      new_arr << u.merge(extrakeys[i])
    end
    return new_arr
  end

  def self.create_users(uids, duns, extrakeys: [])
    uarry = Array.new
    if uids.length == duns.length
      uids.zip(duns, extrakeys).each do |e|
        uarry.push(self.create_user(e))
      end
      return uarry
    else
      puts "arrays not same length"
    end
  end


  def self.build_users_json(array, extrakeys)
    {"users": Factory.add_key(array, extrakeys)}.to_json
  end

end

# 
# usr = Factory.create_users(["1010", "1100"], ["duns1", "duns2"])
# print Factory.build_users_json(usr, [{"verified":true}, {"verified":false}])
