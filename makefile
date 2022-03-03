buildapp:
	rm -rf build/ && flutter build web --release --base-href="/bludurdafdelurpurdurdle/app/" && rm -rf app/ && mkdir app/ && cp -r build/web/* app/