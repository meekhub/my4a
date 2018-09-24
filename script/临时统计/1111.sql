select 
t.id,
case when weather <= 18.515 and weather <= 7.045 then 485.927
  when weather <= 18.515 and weather > 7.045 and weather<= 12.225 then 481.826
    when weather <= 18.515 and weather <= 12.225 and weather > 8.695 and weather <= 10.905 and news <= 93.760 then 477.643
      when weather <= 18.515 and weather <= 12.225 and weather > 8.695 and weather <= 10.905 and news > 93.760 then 471.999
        when weather <= 18.515 and weather <= 12.225 and weather > 8.695 and weather > 10.905 and music <= 41.560 then 474.05
          when weather <= 18.515 and weather <= 12.225 and weather > 8.695 and weather > 10.905 and music > 41.560 then 470.613
            when weather <= 18.515 and weather > 12.225 and weather <= 15.440 and weather <= 13.775 and music <= 40.720 then 471.781
              
          end 
 from tmp_test_01 t;








