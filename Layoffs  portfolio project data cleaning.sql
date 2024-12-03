-- Data Cleaning 


select *
from layoffs ; 

-- 1. Remove Dublicates 
-- 2. Standardize the Data 
-- 3. Null Values or blank Values
-- 4. Remove any Columns or Rows 



CREATE TABLE layoffs__staging 
like layoffs ; 

insert layoffs__staging 
select * 
from layoffs ; 

SELECT *
 FROM layoffs__staging ; 
 
 
 -- 1. Remove Dublicates 


Select * , row_number() over (partition by company , industry , total_laid_off , percentage_laid_off , `date`) as row_num
from layoffs__staging ;


with duplicate_cte As 
( 
Select * , 
row_number() over (partition by company, location , industry , total_laid_off , percentage_laid_off , `date`, stage,country, funds_raised_millions) as row_num
from layoffs__staging 
)
select *
from duplicate_cte
where row_num > 1 ; 

select * 
from layoffs__staging
where company ='Casper';


CREATE TABLE `layoffs__staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL ,
  `row_num` int 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


select *
from layoffs__staging2 ; 

insert into  layoffs__staging2 
 Select * , 
row_number() over (partition by company, location , industry , total_laid_off , percentage_laid_off , `date`, stage,country, funds_raised_millions) as row_num
from layoffs__staging ;


select * 
from layoffs__staging2 
where row_num >1;

Delete 
from layoffs__staging2 
where row_num >1;


-- 2. Standardize the Data  

select company , Trim(company) 
 from layoffs__staging2 ;
 
 update layoffs__staging2
 set company = Trim(company) ; 
 
 ------- 
 
 select distinct industry 
 from layoffs__staging2
 order by 1 ;
 
 select *
 from layoffs__staging2 
 where industry like 'Crypto%' ; 

update layoffs__staging2 
set industry = 'Crypto'
where industry like 'Crypto%' ; 

-------
select distinct country
from layoffs__staging2 
order by 1; 

select *
from layoffs__staging2 
where country like 'United States%';

select distinct country ,  trim( trailing'.'from country)
from layoffs__staging2
order by 1 ;

update layoffs__staging2
set country = trim( trailing'.'from country)
where country like 'United States%' ;

------
select *
from layoffs__staging2;

select `date`,
str_to_date(`date`,'%m/%d/%Y')
from layoffs__staging2;

update layoffs__staging2
set `date`= str_to_date(`date`,'%m/%d/%Y') ;

alter Table layoffs__staging2 
modify column `date` Date ;

-----
-- 3. Null Values or blank Values 


select *
from layoffs__staging2
where industry is null 
or industry = '' ;

update layoffs__staging2
set industry = Null 
where industry = '' ; 


select *
from layoffs__staging2 
where company ='Airbnb';


select t1.industry , t2.industry 
from layoffs__staging2 t1
join layoffs__staging2 t2 
    On t1.company = t2.company
where t1.industry is null 
And t2.industry is not null ;



update layoffs__staging2 t1
join layoffs__staging2 t2 
    On t1.company = t2.company
set t1.industry =t2.industry
where t1.industry is null 
And t2.industry is not null ;

------
-- 4. Remove any Columns or Rows 

select *
from layoffs__staging2
where total_laid_off is null 
And percentage_laid_off is null ; 
 
 
 delete
 from layoffs__staging2
where total_laid_off is null 
And percentage_laid_off is null ; 
 
 ------
 
 alter Table  layoffs__staging2 
 Drop column row_num ; 
 
 select * 
 from layoffs__staging2
 
 