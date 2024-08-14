alter table tc_sff_file add constraint tpc_sff_pk primary key (tc_sff01,tc_sff02,tc_sff03);
alter table tc_sff_file modify tc_sff03 not null;
