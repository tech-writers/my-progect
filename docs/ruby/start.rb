commands = [
  

]

puts "\n****************************  Выполнение команд  **************************************\n"

start_time = Time.now

commands.each do |command|
  puts "Выполняется команда: #{command}"
  system(command)
  puts "\n"
end

end_time = Time.now
execution_time = end_time - start_time
minutes = (execution_time / 60).to_i
seconds = (execution_time % 60).to_i

puts "*************************** Все команды выполнены ****************************"
commit_hash = `git log -1 --format=%H`.strip
puts ""
puts "✅ Хеш последнего коммита: #{commit_hash}"
puts ""
puts "Время начала: #{start_time.strftime('%Y-%m-%d %H:%M:%S')}"
puts "Время окончания: #{end_time.strftime('%Y-%m-%d %H:%M:%S')}"
puts "Общее время: #{execution_time.round(2)} сек (или #{minutes} мин #{seconds} сек)"
