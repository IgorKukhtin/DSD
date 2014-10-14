select *
from dba.Users 
left join dba._pgUsers on _pgUsers.UserId = Users.Id
where Users.Id in (select UserId from dba.ScaleHistory where InsertDate > '2014-06-01' group by UserId  
             union select UserId from dba.ScaleHistory_byObvalka where InsertDate > '2014-06-01' group by UserId)
  and _pgUsers.UserId is null
order by 2


create table dba._pgUsers
(UserId integer not null,
 UserName TVarCharMedium not null,
 Id_pg Integer not null,
PRIMARY KEY (UserId));

insert into _pgUsers (UserId, UserName, Id_pg)
select UserId, UserName,  case when UserId = '1' then 5 else tmp2.Id end as Id_pg

/*select gpInsertUpdate_Object_User (ioId       := 0
                                 , inCode     := ObjectCode
                                 , inUserName := ValueData
                                 , inPassword := 'qwerty123'
                                 , inMemberId := NULL
                                 , inSession  := '5')
from (
select max (UserName) as ValueData, cast (UserId2 as integer) + 1000 as ObjectCode*/
from (
select '1' as UserId, 'Admin' as UserName, '1' as UserId2
union select '335', '������� �.�.', '2'
union select '26', '������� �.�.', '2'
union select '333', '������� �.�. - 1', '2'
union select '376', '������� �.�.-2', '2'
union select '12', '������� �.�.', '3'
union select '29', '���������� �.�.', '7'
union select '93', '���������� �.�. - 1', '7'
union select '21', '������� �.�.', '8'
union select '235', '���������� �.�.', '10'
union select '236', '���������� �.�. -1', '10'
union select '16', '������� �.�.', '12'
union select '95', '������� �.�. - 1', '12'
union select '247', '��������� �. �.', '14'
union select '248', '��������� �. �. - 1', '14'
union select '250', '��������� �. �. - 3', '14'
union select '218', '������ �.', '17'
union select '217', '������ �. - 1', '17'
union select '379', '������ �. �.', '19'
union select '380', '������ �. �. - 1', '19'
union select '150', '������ �.�.-2', '20'
union select '118', '�������� �. �.', '22'
union select '137', '�������� �.�. - 1', '22'
union select '138', '�������� �.�. - 2', '22'
union select '139', '�������� �.�. - 3', '22'
union select '312', '�������� �. �.', '26'
union select '313', '�������� �. �. - 1', '26'
union select '372', '��������� �.�.', '28'
union select '373', '��������� �.�. - 1', '28'
union select '163', '��������� �.�.', '29'
union select '253', '����� �.�.', '31'
union select '254', '����� �.�. - 1', '31'
union select '208', '����� �.�. - 1', '33'
union select '209', '����� �.�. - 2', '33'
union select '210', '����� �.�. - 3', '33'
union select '327', '��������� �.�.', '36'
union select '328', '��������� �.�. - 1', '36'
union select '260', '����������� �.�.', '38'
union select '261', '����������� �.�. - 1', '38'
union select '8', '������� �.�.', '40'
union select '97', '������� �.�. - 1', '40'
union select '273', '��������� �.�.', '41'
union select '63', '������� �.�.', '42'
union select '125', '������� �.�. - 1', '42'
union select '126', '������� �.�. - 2', '42'
union select '325', '������� �.�.', '46'
union select '326', '������� �.�. - 1', '46'
union select '315', '������� �.�.', '48'
union select '316', '������� �.�. - 1', '48'
union select '104', '������� �.�.', '50'
union select '169', '������� �.�.', '50'
union select '374', '������� �.�.', '52'
union select '375', '������� �.�. - 1', '52'
union select '178', '�������� �. �.', '54'
union select '179', '�������� �. �. - 1', '54'
union select '345', '������� �.�.', '56'
union select '346', '������� �.�. - 1', '56'
union select '338', '���������� �. �.', '58'
union select '99', '���������� �. �. - 1', '58'
union select '337', '������� �.�.', '60'
union select '159', '������� �.�. - 1', '60'
union select '114', '�������� �.�.', '61'
) as tmp
/*
group by UserId2
) as tmp
*/
left join 
(select 300523 as Id ,38 as x1, 1002 as Code ,'������� �.�.-2' as Name
union select 300532,38,1003,'������� �.�.'
union select 300546,38,1007,'���������� �.�. - 1'
union select 300520,38,1008,'������� �.�.'
union select 300541,38,1010,'���������� �.�. -1'
union select 300528,38,1012,'������� �.�. - 1'
union select 300549,38,1014,'��������� �. �. - 3'
union select 300525,38,1017,'������ �. - 1'
union select 300540,38,1019,'������ �. �. - 1'
union select 300536,38,1020,'������ �.�.-2'
union select 300535,38,1022,'�������� �.�. - 3'
union select 300531,38,1026,'�������� �. �. - 1'
union select 300530,38,1028,'��������� �.�. - 1'
union select 300545,38,1029,'��������� �.�.'
union select 300533,38,1031,'����� �.�. - 1'
union select 300537,38,1033,'����� �.�. - 3'
union select 300542,38,1036,'��������� �.�. - 1'
union select 300527,38,1038,'����������� �.�. - 1'
union select 300539,38,1040,'������� �.�. - 1'
union select 300534,38,1041,'��������� �.�.'
union select 300550,38,1042,'������� �.�. - 2'
union select 300522,38,1046,'������� �.�. - 1'
union select 300521,38,1048,'������� �.�. - 1'
union select 300526,38,1050,'������� �.�.'
union select 300529,38,1052,'������� �.�. - 1'
union select 300548,38,1054,'�������� �. �. - 1'
union select 300544,38,1056,'������� �.�. - 1'
union select 300524,38,1058,'���������� �. �. - 1'
union select 300538,38,1060,'������� �.�. - 1'
union select 300543,38,1061,'�������� �.�.'
) as tmp2 on tmp2.Code = tmp.UserId2 + 1000