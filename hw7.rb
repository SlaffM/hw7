

class Roles   

  LIST_ROLES = []
  
  attr_accessor :title
  
  def initialize(title, age, gender) 
    @role = []
    @title = title
    @role << { :title => title, :age => age, :gender => gender }
    LIST_ROLES << { :title => title, :age => age, :gender => gender }
  end
  
  def self.list
    LIST_ROLES.each { |item| yield(item) } 
  end  
  
  def each_el
    @role.each { |item| yield(item) }   
  end
  
end

class Actors 
  
  attr_accessor :name, :gender, :topic, :age, :time, :count_play, :text, :time_ar
  
  def initialize(name, gender, age=0, topic="", time=0, text=0) 
    raise ArgumentError, "Noname can not play" if name.nil? || name.empty?
    raise ArgumentError, "Gender must be a male or female (m or f)" unless gender == 'm' || gender == 'f'
    raise ArgumentError, "Speech topic can not be nothing" if topic.nil? || topic.empty?
    raise ArgumentError, "Time must be an integer" unless /[[:digit:]]/.match(time.to_s)
    raise ArgumentError, "Age must be an integer" unless /[[:digit:]]/.match(age.to_s)
    raise ArgumentError, "Text must be an integer" unless /[[:digit:]]/.match(text.to_s)
    @count_play = []    
    @time_ar = []
    @name, @gender, @topic, @age, @time, @text = name, gender, topic, age.to_i, time.to_i, text.to_i
    
  end    
  
end

class Committee  
  
  LIST_COMMITT = []
  
  attr_accessor :actor, :role
  
  attr_reader :time, :good_role
  
  def initialize(actor, role)
    @actor = actor
    @role = role
  end       
  
  def rating          
    
    return "Bad news, #{@actor.name}, not fits to the role #{@role.title}" unless is_fit?
    
    #group of committee
    _m = %w(genry pinki ken jek den) # ken jek den andrey piter jenya)
    _f = %w(jana katya sveta) # sveta rosa anna ksenia)        
    
    #calculate rating
    sum_m = _m.inject(0) do |sum, n| 
      @actor.gender == 'f' && (18..25).include?(@actor.age) ? sum+=rand(8..10) : sum+=rand(1..10)        
    end        
    sum_f = _f.inject(0) do |sum, n| 
      @actor.text <30 ? sum+=rand(1...7) : sum+=rand(1..10)      
    end           
    ocenka = (sum_m+sum_f)/(_f.size+_m.size)
    
    #rating                
    @actor.count_play << { @role.title => ocenka }
    _countPlay = Hash[@actor.count_play.collect{ |item| [item.keys[0], item.values[0]] }]
    
            
    #list roles which actor can play
    _listRoles = @actor.count_play.collect{ |item| item.keys[0] }    
        
    #count time playing for actor
    @actor.time_ar <<  @actor.time 
    @time = @actor.time_ar.reduce(:+)    
    
    #find good role         
    @good_role = _countPlay.key(_countPlay.values.max)       
            
    LIST_COMMITT << {
      :name_actor => @actor.name,
      :gender => @actor.gender,
      :can_play => _listRoles,
      :rating => _countPlay,
      :time => @time,
      :goodRole => @good_role
      }
            
    #result rating avg       
    return "Good, #{@actor.name}, fits to the role #{@role.title}"     
  end       
  
  def self.list
    LIST_COMMITT.each { |item| yield(item) } 
  end  
  
  private
  
  def is_fit? 
    return false unless @actor.count_play.detect { |obj| obj.include?(@role.title)}.nil?    
    @role.each_el do |item|      
      return false unless Array(item[:age]).include?(@actor.age) && @actor.gender.include?(item[:gender])   
    end    
  end    
  
end

#create actors
#p '-----------create actors-----------'
actor = Actors.new("Gena", "m", '40', "test", 30, 46)
actor1 = Actors.new('Tanya', 'f', 6, 'test2', 25, 45)
actor2 = Actors.new('Petr', 'm', 50, 'test3', 25, 45)
 
#create roles
p '-----------create roles-----------'
role1 = Roles.new('kapitan', 40, 'm')
role2 = Roles.new('kapitan1', 40..60, 'm')
role3 = Roles.new('young_girl', 5..8, 'f')
role4 = Roles.new('kapitan2', 40..60, 'm')
Roles.list {|i| p i }


#create speech and committee
p '-----------create speech and committee-----------'
committ1 = Committee.new(actor, role1)
p"rating1 = #{committ1.rating}, time = #{committ1.time}" 

committ2 = Committee.new(actor, role2)
p"rating2 = #{committ2.rating}, time = #{committ2.time}"
 
committ3 = Committee.new(actor, role1)
p"rating3 = #{committ3.rating}"

committ4 = Committee.new(actor, role3)
p"rating4 = #{committ4.rating}"
 
committ5 = Committee.new(actor1, role3)
p"rating5 = #{committ5.rating}"

committ6 = Committee.new(actor, role4)
p"rating6 = #{committ6.rating}, time = #{committ6.time}, good role - #{committ6.good_role}"

committ7 = Committee.new(actor2, role4)
p"rating7 = #{committ7.rating}"

p '-----------viewing result about actors-----------'
Committee.list {|i| p i}
