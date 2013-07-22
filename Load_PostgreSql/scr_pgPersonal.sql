alter table dba.Unit add pgUnitId integer null;
update dba.Unit join _pgUnit on _pgUnit.UnitId = Unit.Id set pgUnitId = _pgUnit.Id;
update dba.Unit join _pgUnit on _pgUnit.UnitId = zc_UnitId_Composition()
  set pgUnitId = _pgUnit.Id
where Unit.Id in (4417,zc_UnitId_CompositionZ());


create table dba._pgPersonal (Id integer not null default autoincrement, UnitId integer not null, pgUnitId integer not null, Id1_Postgres integer null, Id2_Postgres integer null, PRIMARY KEY (UnitId));

insert into dba._pgPersonal (UnitId, pgUnitId)
select Unit.Id, _pgUnit_Zagatov.Id
from dba.Unit 
     left outer join dba._pgUnit as _pgUnit_Zagatov on _pgUnit_Zagatov.ObjectCode = 11
where Unit.Id in (4739 // 7910 АНДРЕЙЧЕНКО заготовитель
                               ,5162 // 8534 Баклажук В. ФЛП заготовитель
                               ,4742 // 7912	ДУБОВСКОЙ заготовитель
                               ,4920 // 8104	ДЬЯЧЕНКО заготов.
                               ,4740 // 7911	ОСИПОВ заготовитель
                               ,5087 // 8459	Чернявский заготов.
                               ,4695 // 7869	ЧУМАК заготовитель
                               );
-- alter table dba._pgPersonal add pgUnitId integer null; update dba._pgPersonal join dba._pgUnit as _pgUnit_Zagatov on _pgUnit_Zagatov.ObjectCode = 11 set pgUnitId = _pgUnit_Zagatov.Id;

update dba.Unit join _pgPersonal on _pgPersonal.UnitId = Unit.Id
  set Unit.Id1_Postgres =null , PersonalId_Postgres= _pgPersonal.Id;



insert into dba._pgPersonal (UnitId, pgUnitId)
select Unit.Id, null
from dba.Unit 
where Unit.ParentId = 4137; -- МО ЛИЦА-ВСЕ


update dba.Unit join _pgPersonal on _pgPersonal.UnitId = Unit.Id
  set Unit.Id1_Postgres =null , PersonalId_Postgres= _pgPersonal.Id;

commit;
