/*
CREATE TABLE _tmp_noDELETE_Partner(
   FromId  INTEGER NOT NULL, 
   ToId    INTEGER NOT NULL);

CREATE TABLE _tmp_noDELETE_Movement(
   MovementId  INTEGER NOT NULL);

*/
with tmpPartner as
               (select Object_Partner.*
                     , trim (coalesce (ObjectString_GLNCode.ValueData, '')) AS GLNCode
                     , trim (trim (coalesce (ObjectString_ShortName.ValueData, '')) || ' ' || coalesce (ObjectString_Address.ValueData, '')) as Address
                     , coalesce (ObjectLink_Partner_Juridical.ChildObjectId, 0) AS JuridicalId
                from Object as Object_Partner
                     inner JOIN ObjectLink AS ObjectLink_Partner_Street
                                           ON ObjectLink_Partner_Street.ObjectId = Object_Partner.Id
                                          AND ObjectLink_Partner_Street.DescId = zc_ObjectLink_Partner_Street()
                     inner JOIN Object as Object_Street on Object_Street.Id = ObjectLink_Partner_Street.ChildObjectId
                                                       and trim (Object_Street.ValueData) <> ''
                     LEFT JOIN ObjectString AS ObjectString_ShortName
                                            ON ObjectString_ShortName.ObjectId = Object_Partner.Id
                                           AND ObjectString_ShortName.DescId = zc_ObjectString_Partner_ShortName()
                     LEFT JOIN ObjectString AS ObjectString_Address
                                            ON ObjectString_Address.ObjectId = Object_Partner.Id
                                           AND ObjectString_Address.DescId = zc_ObjectString_Partner_Address()
                     LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                          ON ObjectLink_Partner_Juridical.ObjectId = Object_Partner.Id
                                         AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                     LEFT JOIN ObjectString AS ObjectString_GLNCode 
                                            ON ObjectString_GLNCode.ObjectId = Object_Partner.Id 
                                           AND ObjectString_GLNCode.DescId = zc_ObjectString_Partner_GLNCode()
                where Object_Partner.DescId = zc_Object_Partner()
               )
   , tmpAdrGLN_all as (select tmpPartner.* from tmpPartner where GLNCode <> '')
--                   select tmpAdrGLN_all.Address, tmpAdrGLN_all.JuridicalId, max (GLNCode), min (GLNCode)
--                   from tmpAdrGLN_all
--                   group by tmpAdrGLN_all.Address, tmpAdrGLN_all.JuridicalId
--                   having max (GLNCode) <>  min (GLNCode)

   , tmpAdrGLN as (select tmpAdrGLN_all.Address, tmpAdrGLN_all.JuridicalId
                   from tmpAdrGLN_all
                   group by tmpAdrGLN_all.Address, tmpAdrGLN_all.JuridicalId
                   having count (*) = 1
                  )
   , tmpAllGLN as (select tmpPartner.*
                   from tmpPartner
                        join tmpAdrGLN on tmpAdrGLN.Address     = tmpPartner.Address
                                      and tmpAdrGLN.JuridicalId = tmpPartner.JuridicalId
                   where tmpPartner.GLNCode <> ''
                  )
   , tmpAdr_err as (select tmpPartner.Address, tmpPartner.JuridicalId
                    from tmpPartner
                    group by tmpPartner.Address, tmpPartner.JuridicalId
                    having count (*) > 1
                   )
   , tmpAll_err as (select tmpPartner.*
                    from tmpPartner
                         join tmpAdr_err on tmpAdr_err.Address     = tmpPartner.Address
                                        and tmpAdr_err.JuridicalId = tmpPartner.JuridicalId
                   )

     -- Find - 1
   , tmpFindGLN_1 as (select tmpAll_err.*, coalesce (tmpAllGLN.Id, 0) AS PartnerId_find
                    from tmpAll_err
                         left join tmpAllGLN on tmpAllGLN.Address     = tmpAll_err.Address
                                            and tmpAllGLN.JuridicalId = tmpAll_err.JuridicalId
                   )
   , tmpMIGLN as (select tmpFindGLN_1.Id AS PartnerId, Count(*) AS Movement_Count, Address, JuridicalId
                  from tmpFindGLN_1
                       inner join MovementLinkObject AS MLO ON MLO.ObjectId = tmpFindGLN_1.Id
                       inner join Movement ON Movement.Id = MLO.MovementId and Movement.DescId = zc_Movement_Sale() and Movement.StatusId = zc_Enum_Status_Complete() and Movement.OperDate >= '01.06.2014'
                  where PartnerId_find = 0 AND GLNCode <> ''
                  group by tmpFindGLN_1.Id, Address, JuridicalId
                 )
   , tmpMIGLN_max as (select Address, JuridicalId, MAX (Movement_Count) AS find_Count from tmpMIGLN group by Address, JuridicalId)
   , tmpFindGLN_MI as (select tmpMIGLN_max.Address, tmpMIGLN_max.JuridicalId, MAX (tmpMIGLN.PartnerId) AS PartnerId_find
                       from tmpMIGLN
                            join tmpMIGLN_max on tmpMIGLN_max.find_Count = tmpMIGLN.Movement_Count and tmpMIGLN_max.Address = tmpMIGLN.Address and tmpMIGLN_max.JuridicalId = tmpMIGLN.JuridicalId
                       group by tmpMIGLN_max.Address, tmpMIGLN_max.JuridicalId
                      )
     -- Find - 2
   , tmpFindGLN_2 as (select tmpFindGLN_1.Id, tmpFindGLN_1.ObjectCode, tmpFindGLN_1.ValueData, tmpFindGLN_1.GLNCode, tmpFindGLN_1.Address, tmpFindGLN_1.JuridicalId
                           , COALESCE (tmpFindGLN_MI.PartnerId_find, 0) AS PartnerId_find
                      from tmpFindGLN_1
                           left join tmpFindGLN_MI on tmpFindGLN_MI.Address     = tmpFindGLN_1.Address
                                                  and tmpFindGLN_MI.JuridicalId = tmpFindGLN_1.JuridicalId
                      where tmpFindGLN_1.PartnerId_find = 0
                     )

      , tmpMI as (select tmpFindGLN_2.Id AS PartnerId, Count(*) AS Movement_Count, Address, JuridicalId
                  from tmpFindGLN_2
                       inner join MovementLinkObject AS MLO ON MLO.ObjectId = tmpFindGLN_2.Id
                       inner join Movement ON Movement.Id = MLO.MovementId and Movement.DescId = zc_Movement_Sale() and Movement.StatusId = zc_Enum_Status_Complete() and Movement.OperDate >= '01.06.2014'
                  where PartnerId_find = 0
                  group by tmpFindGLN_2.Id, Address, JuridicalId
                 )
      , tmpMI_max as (select Address, JuridicalId, MAX (Movement_Count) AS find_Count from tmpMI group by Address, JuridicalId)
      , tmpFind_MI as (select tmpMI_max.Address, tmpMI_max.JuridicalId, MAX (tmpMI.PartnerId) AS PartnerId_find
                       from tmpMI
                            join tmpMI_max on tmpMI_max.find_Count = tmpMI.Movement_Count and tmpMI_max.Address = tmpMI.Address and tmpMI_max.JuridicalId = tmpMI.JuridicalId
                       group by tmpMI_max.Address, tmpMI_max.JuridicalId
                      )
         -- Find - 3
      , tmpFind_3 as (select tmpFindGLN_2.Id, tmpFindGLN_2.ObjectCode, tmpFindGLN_2.ValueData, tmpFindGLN_2.GLNCode, tmpFindGLN_2.Address, tmpFindGLN_2.JuridicalId
                           , tmpFind_MI.PartnerId_find
                      from tmpFindGLN_2
                           left join tmpFind_MI on tmpFind_MI.Address     = tmpFindGLN_2.Address
                                               and tmpFind_MI.JuridicalId = tmpFindGLN_2.JuridicalId
                      where tmpFindGLN_2.PartnerId_find = 0
                     )

         -- Find - tmp
      , tmpFind_tmp as (select Id, ObjectCode, ValueData, GLNCode, Address, JuridicalId, PartnerId_find from tmpFindGLN_1 where PartnerId_find <> 0
                     union all
                      select Id, ObjectCode, ValueData, GLNCode, Address, JuridicalId, PartnerId_find from tmpFindGLN_2 where PartnerId_find <> 0
                     union all
                      select Id, ObjectCode, ValueData, GLNCode, Address, JuridicalId, PartnerId_find from tmpFind_3 where PartnerId_find <> 0
                     )

      , tmpFind_no as (select tmpAll_err.*
                      from tmpAll_err
                           left join tmpFind_tmp on tmpFind_tmp.Id = tmpAll_err.Id
                      where tmpFind_tmp.Id is null
                     )

         -- Find - 4
      , tmpFind_4_tmp as (select Address, JuridicalId, max (Id) AS PartnerId_find from tmpFind_no group by Address, JuridicalId)
      , tmpFind_4 as (select tmpFind_no.Id, tmpFind_no.ObjectCode, tmpFind_no.ValueData, tmpFind_no.GLNCode, tmpFind_no.Address, tmpFind_no.JuridicalId
                           , tmpFind_4_tmp.PartnerId_find
                      from tmpFind_no
                           left join tmpFind_4_tmp on tmpFind_4_tmp.Address     = tmpFind_no.Address
                                                  and tmpFind_4_tmp.JuridicalId = tmpFind_no.JuridicalId
                     )

         -- Find - Result
      , tmpFind_result as (select * from tmpFind_tmp where Id <> PartnerId_find
                          union all
                           select * from tmpFind_4 where Id <> PartnerId_find
                          )

-- select * from tmpFind_result order by Address, JuridicalId

         -- Find - Movement
      , tmpFind_Movement as (select MovementItem.MovementId, Movement.OperDate, Movement.DescId from tmpFind_result join MovementItemLinkObject on MovementItemLinkObject.ObjectId = tmpFind_result.Id join MovementItem on MovementItem.Id = MovementItemId join Movement on Movement.Id = MovementId and Movement.StatusId = zc_Enum_Status_Complete() group by MovementItem.MovementId, Movement.OperDate, Movement.DescId
                            union
                             select MovementItem.MovementId, Movement.OperDate, Movement.DescId from tmpFind_result join MovementItem on MovementItem.ObjectId = tmpFind_result.Id join Movement on Movement.Id = MovementId and Movement.StatusId = zc_Enum_Status_Complete() group by MovementItem.MovementId, Movement.OperDate, Movement.DescId
                            union
                             select MovementLinkObject.MovementId, Movement.OperDate, Movement.DescId from tmpFind_result join MovementLinkObject on MovementLinkObject.ObjectId = tmpFind_result.Id join Movement on Movement.Id = MovementId and Movement.StatusId = zc_Enum_Status_Complete() group by MovementLinkObject.MovementId, Movement.OperDate, Movement.DescId
                            )
-- select count(*), min(OperDate), max (OperDate) from tmpFind_Movement
select tmpFind_Movement.*, tmpFind_result.Id, tmpFind_result.PartnerId_find, MovementItemLinkObject.ObjectId, '1' from tmpFind_Movement join MovementItem on MovementItem.MovementId = tmpFind_Movement.MovementId join MovementItemLinkObject on MovementItemLinkObject.MovementItemId = MovementItem.Id join tmpFind_result on tmpFind_result.PartnerId_find = MovementItemLinkObject.ObjectId where tmpFind_Movement.DescId <> zc_Movement_ProfitLossService()
union all
select tmpFind_Movement.*, tmpFind_result.Id, tmpFind_result.PartnerId_find, MovementItem.ObjectId, '2' from tmpFind_Movement join MovementItem on MovementItem.MovementId = tmpFind_Movement.MovementId join tmpFind_result on tmpFind_result.PartnerId_find = MovementItem.ObjectId
union all
select tmpFind_Movement.*, tmpFind_result.Id, tmpFind_result.PartnerId_find, MovementLinkObject.ObjectId, '3' from tmpFind_Movement join MovementLinkObject on MovementLinkObject.MovementId = tmpFind_Movement.MovementId join tmpFind_result on tmpFind_result.PartnerId_find = MovementLinkObject.ObjectId


-- insert into _tmp_noDELETE_Partner (FromId, ToId) select Id, PartnerId_find from tmpFind_result
-- insert into _tmp_noDELETE_Movement (MovementId) select MovementId from tmpFind_Movement
