-- 실행계획의 세부사항을 확인 하기 위해 필요한 권한
grant select on v_$session to hr;
grant select on v_$sql to hr;
grant select on v_$sql_plan to hr;
grant select on v_$sql_plan_statistics to hr;
grant select on v_$sql_plan_statistics_all to hr;