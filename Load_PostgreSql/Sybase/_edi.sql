/*
select  PartnerId_pg
from 
(
select  fIsClient_EDI_Kind (Unit.Id , 1) as isInvoice
      , fIsClient_EDI_Kind (Unit.Id , 2) as isDesadv
      , fIsClient_EDI_Kind (Unit.Id , 3) as Ordrsp
      , _pgPartner.PartnerId_pg
      , Unit.*

from Unit
     left outer join (select max (isnull(_pgPartner.PartnerId_pg,0)) as PartnerId_pg, OKPO, UnitId, Main from dba._pgPartner where trim(OKPO) <> '' and _pgPartner.PartnerId_pg <> 0 and UnitId <>0 and Main <> 0 group by OKPO, UnitId, Main
                     ) as _pgPartner on _pgPartner.UnitId = Unit.Id -- _find
where fIsClient_EDI (Unit.Id) = zc_rvYes()
-- and isnull (_pgPartner.PartnerId_pg, 0) = 0
group by isInvoice
      , isDesadv
      , Ordrsp
      , _pgPartner.PartnerId_pg
) as tmp

group by PartnerId_pg
having count (*) >1
*/
select case when isInvoice = 0 and PartnerId  <>0 then lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Partner_EdiInvoice(), PartnerId , TRUE) end
     , case when isDesadv = 0 and PartnerId  <>0 then lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Partner_EdiDesadv(), PartnerId , TRUE) end
     , case when Ordrsp = 0 and PartnerId  <>0 then lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Partner_EdiOrdspr(), PartnerId , TRUE) end
from
(select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 17737 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 328850 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 79367 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18210 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 257054 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18223 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 256282 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18177 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 17751 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 79249 as PartnerId 
union select 1 as isInvoice, 1 as isDesadv, 0 as Ordrsp, 256557 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 79425 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 140070 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 82574 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 79232 as PartnerId 
union select 0 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 17674 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 96885 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18196 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 256288 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18190 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 399431 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 79226 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 79372 as PartnerId 
union select 0 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 17680 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 17876 as PartnerId 
union select 0 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 79187 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 257053 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 17731 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 108425 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 17736 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 79424 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 79366 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 257370 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18222 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 17869 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 328849 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18209 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 106628 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 256281 as PartnerId 
union select 0 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 79186 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 17750 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 17961 as PartnerId 
union select 0 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 17673 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18167 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 256496 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 341959 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18176 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18172 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 399430 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18203 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 348454 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18189 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 79225 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 345553 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 0 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 17730 as PartnerId 
union select 0 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 17672 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 329517 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18202 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 96891 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 17743 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 328690 as PartnerId 
union select 0 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 17667 as PartnerId 
union select 0 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 17686 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18188 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 273756 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 82566 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18183 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 310205 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 310570 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 268755 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 333719 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18208 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 133566 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 17749 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 79365 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18221 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 257052 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 328848 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 79224 as PartnerId 
union select 0 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 313098 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 0 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18220 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 256287 as PartnerId 
union select 0 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 17685 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 329516 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 17742 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 328689 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 17729 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 79364 as PartnerId 
union select 0 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 313097 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18215 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18182 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 17748 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 329787 as PartnerId 
union select 0 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 17666 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 268754 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 82565 as PartnerId 
union select 0 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 17679 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18201 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 17246 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 17728 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 79371 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 17741 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 328688 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 17880 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 268753 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 79423 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 270214 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 79093 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 257323 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 256495 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 256286 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 339382 as PartnerId 
union select 0 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 17665 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18200 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 135178 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 17875 as PartnerId 
union select 0 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 313096 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18214 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 279784 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18181 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 17755 as PartnerId 
union select 0 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 17684 as PartnerId 
union select 0 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 17678 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18195 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 268751 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 96888 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 79370 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 268752 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18194 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 79422 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 96883 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 96898 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 17740 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 138571 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 328853 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 256285 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 17754 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 17874 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 257322 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18213 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 257504 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 153413 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 17952 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 17735 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18207 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 17793 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18171 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 328847 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 396929 as PartnerId 
union select 0 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 17677 as PartnerId 
union select 0 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 17660 as PartnerId 
union select 1 as isInvoice, 1 as isDesadv, 0 as Ordrsp, 17181 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18180 as PartnerId 
union select 0 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 0 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 17792 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18212 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 309292 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 79421 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 17873 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 96895 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 17734 as PartnerId 
union select 0 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 310569 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18187 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 135176 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 256284 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 79477 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 79369 as PartnerId 
union select 0 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 17676 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 17753 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 96897 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18193 as PartnerId 
union select 0 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 17671 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18206 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 257321 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 328852 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 133678 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18170 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 0 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 273806 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 268758 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 328687 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 257056 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 329515 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18169 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 79363 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 17752 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 17747 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 142079 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 17733 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 17727 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 97771 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 17799 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 309834 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 268833 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 79368 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18219 as PartnerId 
union select 0 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 17670 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18192 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18186 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18205 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18185 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 328686 as PartnerId 
union select 1 as isInvoice, 1 as isDesadv, 0 as Ordrsp, 295647 as PartnerId 
union select 0 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 17669 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 273858 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18224 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 268807 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 257702 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 79362 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 268757 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18168 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18204 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 96893 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18218 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 77865 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 144985 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 329514 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 301894 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18199 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 17726 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 17971 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 17746 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 17732 as PartnerId 
union select 0 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 17683 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 17879 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 17798 as PartnerId 
union select 1 as isInvoice, 1 as isDesadv, 0 as Ordrsp, 184559 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 17878 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 79361 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 96887 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 17845 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 79205 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 77927 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18198 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 273857 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18175 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 77864 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 17864 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 97048 as PartnerId 
union select 1 as isInvoice, 1 as isDesadv, 0 as Ordrsp, 17172 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 17745 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 328685 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 17791 as PartnerId 
union select 0 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 17682 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18217 as PartnerId 
union select 0 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 17668 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18179 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 329513 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18184 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 345841 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 329598 as PartnerId 
union select 1 as isInvoice, 1 as isDesadv, 0 as Ordrsp, 247918 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 79374 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 140836 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 256283 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 403515 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18174 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 328851 as PartnerId 
union select 0 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 17681 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 273856 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18197 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 79373 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 17744 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 329512 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18178 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 79227 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 17838 as PartnerId 
union select 0 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 17675 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 79250 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18216 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 79426 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 257055 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 79360 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 1 as Ordrsp, 329788 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 302012 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18191 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 18211 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 17877 as PartnerId 
union select 0 as isInvoice, 1 as isDesadv, 1 as Ordrsp, 132864 as PartnerId 
union select 1 as isInvoice, 0 as isDesadv, 0 as Ordrsp, 77926 as PartnerId 
) as a
-- inner join ObjectBoolean on ObjectBoolean.ObjectId = PartnerId and descid IN (zc_ObjectBoolean_Partner_EdiInvoice(), zc_ObjectBoolean_Partner_EdiDesadv(), zc_ObjectBoolean_Partner_EdiOrdspr()) and valueData = true
-- 18216;30;15550;"Фудмаркет ТОВ м. Черкаси вул. Г.Сталінграда 34";f;