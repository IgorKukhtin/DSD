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
union select '335', 'Азарова И.В.', '2'
union select '26', 'Бабенко В.П.', '2'
union select '333', 'Бабенко В.П. - 1', '2'
union select '376', 'Бабенко В.П.-2', '2'
union select '12', 'Волобой Н.Н.', '3'
union select '29', 'Гандрабура В.А.', '7'
union select '93', 'Гандрабура В.А. - 1', '7'
union select '21', 'Глотова В.А.', '8'
union select '235', 'Глушаченко А.П.', '10'
union select '236', 'Глушаченко А.П. -1', '10'
union select '16', 'Загреба М.П.', '12'
union select '95', 'Загреба М.П. - 1', '12'
union select '247', 'Кириченко М. А.', '14'
union select '248', 'Кириченко М. А. - 1', '14'
union select '250', 'Кириченко М. А. - 3', '14'
union select '218', 'Комков И.', '17'
union select '217', 'Комков И. - 1', '17'
union select '379', 'Кубрак Т. В.', '19'
union select '380', 'Кубрак Т. В. - 1', '19'
union select '150', 'Кушнир Т.П.-2', '20'
union select '118', 'Мирошник Ю. С.', '22'
union select '137', 'Мирошник Ю.С. - 1', '22'
union select '138', 'Мирошник Ю.С. - 2', '22'
union select '139', 'Мирошник Ю.С. - 3', '22'
union select '312', 'Новицкая О. Н.', '26'
union select '313', 'Новицкая О. Н. - 1', '26'
union select '372', 'Панасенко П.Н.', '28'
union select '373', 'Панасенко П.Н. - 1', '28'
union select '163', 'Петлёваный М.М.', '29'
union select '253', 'Пикуш А.В.', '31'
union select '254', 'Пикуш А.В. - 1', '31'
union select '208', 'Повар Л.Г. - 1', '33'
union select '209', 'Повар Л.Г. - 2', '33'
union select '210', 'Повар Л.Г. - 3', '33'
union select '327', 'Полежайко А.П.', '36'
union select '328', 'Полежайко А.П. - 1', '36'
union select '260', 'Пономаренко А.Р.', '38'
union select '261', 'Пономаренко А.Р. - 1', '38'
union select '8', 'Прибега А.В.', '40'
union select '97', 'Прибега А.В. - 1', '40'
union select '273', 'Прилуцкий С.В.', '41'
union select '63', 'Рыбалко В.В.', '42'
union select '125', 'Рыбалко В.В. - 1', '42'
union select '126', 'Рыбалко В.В. - 2', '42'
union select '325', 'Рыженко Д.А.', '46'
union select '326', 'Рыженко Д.А. - 1', '46'
union select '315', 'Сафонов Б.А.', '48'
union select '316', 'Сафонов Б.А. - 1', '48'
union select '104', 'Северин В.И.', '50'
union select '169', 'Северин В.И.', '50'
union select '374', 'Таряник И.В.', '52'
union select '375', 'Таряник И.В. - 1', '52'
union select '178', 'Фурсенко Д. А.', '54'
union select '179', 'Фурсенко Д. А. - 1', '54'
union select '345', 'Шаповал Я.А.', '56'
union select '346', 'Шаповал Я.А. - 1', '56'
union select '338', 'Шаповалова Л. В.', '58'
union select '99', 'Шаповалова Л. В. - 1', '58'
union select '337', 'Шеремет Е.Н.', '60'
union select '159', 'Шеремет Е.Н. - 1', '60'
union select '114', 'Яковенко И.Г.', '61'
) as tmp
/*
group by UserId2
) as tmp
*/
left join 
(select 300523 as Id ,38 as x1, 1002 as Code ,'Бабенко В.П.-2' as Name
union select 300532,38,1003,'Волобой Н.Н.'
union select 300546,38,1007,'Гандрабура В.А. - 1'
union select 300520,38,1008,'Глотова В.А.'
union select 300541,38,1010,'Глушаченко А.П. -1'
union select 300528,38,1012,'Загреба М.П. - 1'
union select 300549,38,1014,'Кириченко М. А. - 3'
union select 300525,38,1017,'Комков И. - 1'
union select 300540,38,1019,'Кубрак Т. В. - 1'
union select 300536,38,1020,'Кушнир Т.П.-2'
union select 300535,38,1022,'Мирошник Ю.С. - 3'
union select 300531,38,1026,'Новицкая О. Н. - 1'
union select 300530,38,1028,'Панасенко П.Н. - 1'
union select 300545,38,1029,'Петлёваный М.М.'
union select 300533,38,1031,'Пикуш А.В. - 1'
union select 300537,38,1033,'Повар Л.Г. - 3'
union select 300542,38,1036,'Полежайко А.П. - 1'
union select 300527,38,1038,'Пономаренко А.Р. - 1'
union select 300539,38,1040,'Прибега А.В. - 1'
union select 300534,38,1041,'Прилуцкий С.В.'
union select 300550,38,1042,'Рыбалко В.В. - 2'
union select 300522,38,1046,'Рыженко Д.А. - 1'
union select 300521,38,1048,'Сафонов Б.А. - 1'
union select 300526,38,1050,'Северин В.И.'
union select 300529,38,1052,'Таряник И.В. - 1'
union select 300548,38,1054,'Фурсенко Д. А. - 1'
union select 300544,38,1056,'Шаповал Я.А. - 1'
union select 300524,38,1058,'Шаповалова Л. В. - 1'
union select 300538,38,1060,'Шеремет Е.Н. - 1'
union select 300543,38,1061,'Яковенко И.Г.'
) as tmp2 on tmp2.Code = tmp.UserId2 + 1000