.PHONY: quick-install start stop logs clean test

quick-install:
	chmod +x quick-setup.sh
	./quick-setup.sh

start:
	chmod +x start-app.sh
	./start-app.sh

stop:
	docker-compose down

logs:
	docker-compose logs -f

oracle-logs:
	docker logs -f oracle-xe

test:
	@echo "🔗 Bağlantı test ediliyor..."
	@docker exec oracle-xe sqlplus -S hospital/hospital123@localhost:1521/XE <<< "SELECT 'Bağlantı başarılı!' FROM DUAL;" || echo "❌ Bağlantı hatası!"

clean:
	docker-compose down -v
	docker system prune -f

db-shell:
	docker exec -it oracle-xe sqlplus hospital/hospital123@localhost:1521/XE

help:
	@echo "🏥 Hastane Yönetim Sistemi"
	@echo "========================="
	@echo "make quick-install  # Hızlı kurulum (önerilen)"
	@echo "make start         # Uygulamayı başlat"
	@echo "make stop          # Servisleri durdur"
	@echo "make logs          # Tüm logları göster"
	@echo "make oracle-logs   # Sadece Oracle logları"
	@echo "make test          # Bağlantıyı test et"
	@echo "make db-shell      # Oracle SQL shell"
	@echo "make clean         # Temizle"
