/* Q1 : Who is senior most employee based on job title*/
select * from employee
order by levels
limit 1;

/* Q2: Which countries have the most Invoices?*/
select count(*) as c,billing_country
from invoice
group by billing_country
order by c desc; 

/* Q3 : What are top 3 values of total invoice*/
select total from invoice
order by total desc
limit 3;

/*Q4 : Q4: Which city has the best customers? We would like to throw a
promotional Music Festival in the city we made the most money. Write a
query that returns one city that has the highest sum of invoice totals.
Return both the city name & sum of all invoice totals*/

select billing_city,sum(total) as invoice_total from invoice
group by billing_city
order by invoice_total desc;

/* Q5: Who is the best customer? The customer who has spent the most
money will be declared the best customer. Write a query that returns
the person who has spent the most money.*/
select customer.customer_id,first_name,last_name, sum(invoice.total) as total from invoice
inner join customer on  customer.customer_id = invoice.customer_id
group by customer_id
order by total desc
limit 1;

/*Q 6: Write query to return the email, first name, last name, & Genre
of all Rock Music listeners. Return your list ordered alphabetically
by email starting with A*/
select distinct email, first_name, last_name from customer
join invoice on customer.customer_id=invoice.customer_id
join invoice_line on invoice.invoice_id=invoice_line.invoice_id
where track_id in (
	select track_id from track
	join genre on track.genre_id=genre.genre_id
	where genre.name like "Rock")
order by email;

/*Q7: Let's invite the artists who have written the most rock music in
our dataset. Write a query that returns the Artist name and total
track count of the top 10 rock bands*/
select artist.artist_id,artist.name,count(artist.artist_id) as num_of_songs from track
join album2 on album2.album_id=track.album_id
join artist on artist.artist_id=album2.artist_id
join genre on track.genre_id=genre.genre_id
where genre.name like "Rock"
group by artist.artist_id
order by num_of_songs desc
limit 10;

/* Q8: Return all the track names that have a song length longer than
the average song length. Return the Name and Milliseconds for
each track. Order by the song length with the longest songs listed
first.*/ 
SELECT name,milliseconds
FROM track
WHERE milliseconds > (
SELECT AVG(milliseconds) AS avg_track_length
FROM track)
ORDER BY milliseconds DESC;

/* Q9: Find how much amount spent by each customer on artists? Write a
query to return customer name, artist name and total spent*/
SELECT customer.first_name, customer.last_name, artist.name, SUM(invoice_line.unit_price * invoice_line.quantity) AS total_spent
FROM customer
JOIN invoice  ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice_line.invoice_id = invoice.invoice_id
JOIN track ON track.track_id = invoice_line.track_id
JOIN album2 ON album2.album_id = track.album_id
JOIN artist ON artist.artist_id = album2.artist_id
GROUP BY customer.customer_id, customer.first_name, customer.last_name, artist.name
ORDER BY total_spent DESC;

/* Q10: We want to find out the most popular music Genre for each country.
We determine the most popular genre as the genre with the highest
amount of purchases. Write a query that returns each country along with
the top Genre. For countries where the maximum number of purchases
is shared return all Genres.*/
SELECT c.country, g.name AS genre
FROM invoice i
INNER JOIN invoice_line il ON i.invoice_id = il.invoice_id
INNER JOIN track t ON il.track_id = t.track_id
INNER JOIN genre g ON t.genre_id = g.genre_id
INNER JOIN customer c ON i.customer_id = c.customer_id
GROUP BY c.country, g.name
HAVING SUM(il.quantity) = (
  SELECT MAX(total_quantity)
  FROM (
    SELECT c2.country, SUM(il2.quantity) AS total_quantity
    FROM invoice_line il2
    INNER JOIN invoice i2 ON il2.invoice_id = i2.invoice_id
    INNER JOIN customer c2 ON i2.customer_id = c2.customer_id
    GROUP BY c2.country
  ) AS subquery
  WHERE subquery.country = c.country
);

