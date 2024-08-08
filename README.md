# doer

doer is a ruby class that completes tasks that you want to schedule and possibly update even while an existing task is being executed. It is useful for handling tasks in gui applications with user input. 

## Use

Here is a code that explains what doer does. 

~~~ruby
require "doer"

doer = Doer.new(1, 0.1)
doer.task do
  # Do something that takes long
  sleep 10
  puts "I slept for 10 seconds"
end
sleep 2  # NOTICE THIS LINE
doer.task do
  puts "Task A"
end
doer.task do
  puts "Task B"
end
sleep 15
~~~

prints 

~~~
I slept for 10 seconds
Task B
~~~

What we first did is we added a task to sleep 10 seconds and print "I slept for 10 seconds". Soon after that Doer started its `dloop`. 
It started checking every 0.1 seconds whether last time something was done is alread 1 second or more in the past. For this example, since 
we have `sleep 2`, doer started doing the task. After `sleep 2` we changed the task to printing `Task A`, but it was too late to change it
since the previous task already started. So perhaps doer will do it as soon as the ongoing task is finished. But we changed the task
again to print "Task B", so doer will just print "Task B". 


On the other hand, 

~~~ruby
require "doer"

doer = Doer.new(1, 0.1)
doer.task do
  # Do something that takes long
  sleep 10
  puts "I slept for 10 seconds"
end
doer.task do
  puts "Task A"
end
doer.task do
  puts "Task B"
end
sleep 15
~~~

prints

~~~
Task B
~~~

This time `sleep 2` is removed, so doer can change the task to printing "Task B" before anything else is done. In the end we just
see "Task B" on the screen. 
