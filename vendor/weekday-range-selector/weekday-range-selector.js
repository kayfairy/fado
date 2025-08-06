var weekdayRangeSlider = {
    container: null,
    inDrag: false,
    height: 100,
    width: 600,
    date: new Date('2017-01-01'),
    locale: ['en-GB', {
        weekday: 'short',
        year: 'numeric',
        month: 'short',
        day: 'numeric'
    }],
    pointerStartWeekday: null,
    pointerEndWeekday: null,
    label: null,
    input: null,
    days: [],
    start: 0,
    stop: 6,
    init: function(containerId) {
        for (var i = 0; i < 7; i++) {
            this.days[i] = {
                name: this.date.toLocaleString(this.locale[0], {
                    weekday: 'long'
                }),
                sName: this.date.toLocaleString(this.locale[0], {
                    weekday: 'short'
                })
            };
            this.date.setDate(this.date.getDate() + 1);
        }
        this.days.push(this.days.splice(0, 1)[0]);
        for (var el of document.getElementById(containerId).children) {
            if (el.className.baseVal == 'slider-start-weekday') {
                this.pointerStartWeekday = el;
            }
            if (el.className.baseVal == 'slider-end-weekday') {
                this.pointerEndWeekday = el;
            }
            if (el.className.baseVal == 'slider-weekday') {
                this.width = parseInt(el.parentElement.clientWidth);
            }
            if (el.className == 'range') {
                this.label = el;
            }
            if (el.className == 'input') {
                this.input = el;
            }
        }
        this.container = document.getElementById(containerId);
        var slider = this;
        if (this.container.dataset.start != undefined && this.container.dataset.stop != undefined) {
            this.start = parseInt(this.container.dataset.start);
            this.stop = parseInt(this.container.dataset.stop);
        }
        this.updateScreenValue();
        this.container.addEventListener('mousedown', function(event) {
            slider.inDrag = true;
            event.start = slider.start;
            event.stop = slider.stop;
            slider.onMove(event);
            slider.drag(event, this);
        });
        this.container.addEventListener('touchstart', function(event) {
            slider.inDrag = true;
            event.start = slider.start;
            event.stop = slider.stop;
            slider.onMove(event);
            slider.drag(event, this);
        });
        this.container.addEventListener('mouseup', function(event) {
            slider.inDrag = false;
            event.start = slider.start;
            event.stop = slider.stop;
            slider.onChange(event);
            slider.drag(event, this);
            slider.scrollToValue(event, this);
        });
        this.container.addEventListener('mouseleave', function(event) {
            if (slider.inDrag) {
                slider.inDrag = false;
                slider.onChange(event);
                slider.drag(event, this);
                slider.scrollToValue(event, this);
            }
        });
        this.container.addEventListener('touchend', function(event) {
            slider.inDrag = false;
            event.start = slider.start;
            event.stop = slider.stop;
            slider.onChange(event);
            slider.drag(event, this);
            slider.scrollToValue(event, this);
        });
        this.container.addEventListener('mousemove', function(event) {
            event.start = slider.start;
            event.stop = slider.stop;
            slider.onMove(event);
            slider.drag(event, this);
        });
        this.container.addEventListener('touchmove', function(event) {
            event.start = slider.start;
            event.stop = slider.stop;
            slider.onMove(event);
            slider.drag(event, this);
            event.preventDefault();
        });
        return this;
    },
    getCoordinates: function(event, container) {
        if (event.clientX != undefined && event.clientY != undefined) {
            var pX = event.clientX;
            var pY = event.clientY;
        } else if (event.touches[0] != undefined) {
            var pX = event.touches[0].clientX;
            var pY = event.touches[0].clientY;
        } else {
            var pX = event.changedTouches[0].clientX;
            var pY = event.changedTouches[0].clientY;
        }
        var rect = container.getBoundingClientRect();
        pX = pX - rect.left;
        pY = pY - rect.top;
        if (pX > this.width) {
            pX = this.width;
        }
        if (pX < 0) {
            pX = 0;
        }
        return [pX, pY];
    },
    drag: function(event, container) {
        if (this.inDrag && !event.defaultPrevented) {
            var coord = this.getCoordinates(event, container);
            if(parseInt(this.pointerEndWeekday.style.marginLeft) - coord[0] < coord[0] - parseInt(this.pointerStartWeekday.style.marginLeft)) {
                this.pointerEndWeekday.style.marginLeft = coord[0] + 'px';
            } else {
                this.pointerStartWeekday.style.marginLeft = coord[0] + 'px';
            }
        }
    },
    scrollToValue: function(event, container) {
        var coord = this.getCoordinates(event, container);
        var offsetLeft =  coord[0] - (coord[0] % (this.width / 6));
        var offsetRight =  (this.width / 6) + coord[0] - (coord[0] % (this.width / 6));
        if (coord[0] - offsetLeft <  offsetRight - coord[0]) {
            offset = offsetLeft;
        } else {
            offset = offsetRight;
        }
        if(parseInt(this.pointerEndWeekday.style.marginLeft) - coord[0] < coord[0] - parseInt(this.pointerStartWeekday.style.marginLeft)) {
            this.pointerEndWeekday.style.marginLeft = offset + 'px';
        } else {
            this.pointerStartWeekday.style.marginLeft = offset + 'px';
        }
        this.start = Math.round(parseInt(this.pointerStartWeekday.style.marginLeft) / (this.width / 6));
        this.stop = Math.round(parseInt(this.pointerEndWeekday.style.marginLeft) / (this.width / 6));
        this.updateScreenValue();
    },
    updateScreenValue: function() {
        var value = this.days[this.start].sName + '-' + this.days[this.stop].sName;
        if (this.days[this.start].sName == this.days[this.stop].sName) {
            value = this.days[this.start].sName;
        }
        this.label.innerHTML = value;
        this.input.value = this.start + '-' + this.stop;
        this.pointerStartWeekday.style.marginLeft = this.start * (this.width / 6) + 'px';
        this.pointerEndWeekday.style.marginLeft = this.stop * (this.width / 6) + 'px';
    },
    onMove: function(event) {},
    onChange: function(event) {}
}
function WeekDayRangeSelector(containerId, options = {}) {
    var obj = Object.create(Object.assign(weekdayRangeSlider, options));
    return obj.init(containerId);
}
