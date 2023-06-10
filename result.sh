file_path="tmdb-movies.csv"

# Câu 1:
echo "Câu 1: lưu vào file released-tmdb-movies.csv"
csvsort -c release_date $file_path > released-tmdb-movies.csv

# Câu 2:
echo "Câu 2: lưu vào file vote-tmdb-movies.csv"
csvsql --query 'SELECT * FROM "tmdb-movies" WHERE vote_average > 7.5' --snifflimit 0 $file_path > vote-tmdb-movies.csv

# Câu 3:
echo "Câu 3.1: Các phim có doanh thu lớn nhất"
max_value=$(csvstat -c revenue --max tmdb-movies.csv)
csvgrep -c 5 -m "$max_value" $file_path | csvcut -c 6,5

echo "Câu 3.2: Các phim có doanh thu thấp nhất"
min_value=$(csvstat -c revenue --min tmdb-movies.csv)
csvgrep -c 5 -r "^$min_value" $file_path | csvcut -c 6,5

# Câu 4:
echo "Câu 4: Tổng doanh thu thấp nhất"
csvstat --sum -c revenue tmdb-movies.csv

# Câu 5:
echo "Câu 5: Top 10 lợi nhuận"
csvcut -c id,original_title,revenue_adj,budget_adj tmdb-movies.csv | csvsql --query 'SELECT id,original_title,revenue_adj - budget_adj AS profit FROM stdin' | csvsort -r -c profit | head -n 11

# Câu 6:
echo "Câu 6.1: Top 10 đạo diễn có nhiều phim nhất"
csvsql --query 'SELECT director, COUNT(*) AS movie_count FROM "tmdb-movies" GROUP BY director HAVING director IS NOT NULL ORDER BY movie_count DESC' tmdb-movies.csv | head -n 10

echo "Câu 6.2: Top 10 diễn viên có nhiều phim nhất"
csvcut -c cast tmdb-movies.csv |   awk -F'|' '{for (i=1; i<=NF; i++) print $i}' | sort | uniq -c | sort -k1 -nr | head -n 10
