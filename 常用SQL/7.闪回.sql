--иа╩ь
CREATE TABLE UOP_ACT1.tf_b_flow_log_4 AS
SELECT * FROM UOP_ACT1.tf_b_flow_log AS OF TIMESTAMP TO_TIMESTAMP ('2017-11-27 15:38:00', 'yyyy-mm-dd hh24:mi:ss');

flashback table ucr_crm.tm_b_five_group_user to before drop;


insert into ucr_crm1.tf_bh_trade 
select * from ucr_crm1.tf_b_trade AS OF TIMESTAMP TO_TIMESTAMP ('2018-06-22 14:10:00', 'yyyy-mm-dd hh24:mi:ss') a
where a.trade_id=1018061262015638;