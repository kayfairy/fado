var CircleSlider = {
    v1: 0,
    v2: 0,
    canvas: null,
    container: null,
    cOut: null,
    cIn: null,
    label: null,
    input: null,
    arcCanvas: null,
    arcWidth: 2,
    R1: 80,
    cX1: 100,
    cY1: 100,
    R2: 60,
    cX2: 110,
    cY2: 110,
    value: null,
    inDrag: false,
    dragCircle: null,
    dragPointDistance: 15,
    drag: function(pX, pY) {
        var vX = pX - this.cX1;
        var vY = pY - this.cY1;
        var vSd = Math.sqrt(vX * vX + vY * vY);
        var aX1 = this.cX1 + vX / vSd * this.R1;
        var aY1 = this.cX1 + vY / vSd * this.R1;
        var vX = pX - aX1;
        var vY = pY - aY1;
        var d1 = Math.sqrt(vX * vX + vY * vY);
        var a = Math.acos((this.cY1 - aY1) / this.R1) * 180 / Math.PI;
        if (aX1 < this.cX1) {
            a = 360 - a;
        }
        var vX = pX - this.cX2;
        var vY = pY - this.cY2;
        var vSd = Math.sqrt(vX * vX + vY * vY);
        var aX2 = this.cX2 + vX / vSd * this.R2;
        var aY2 = this.cY2 + vY / vSd * this.R2;
        var vX = pX - aX2;
        var vY = pY - aY2;
        var d2 = Math.sqrt(vX * vX + vY * vY);
        var b = Math.acos((this.cY2 - aY2) / this.R2) * 180 / Math.PI;
        if (aX2 < this.cX2) {
            b = 360 - b;
        }
        var values = Object.assign({
            'aX1': aX1,
            'aY1': aY1,
            'aX2': aX2,
            'aY2': aY2,
            'a': a,
            'b': b,
            'd1': d1,
            'd2': d2
        });
        return values;
    },
    adjustInnerPointer: function(value, maximum) {
        var pX = this.cX2 - this.R2 * Math.cos(value / maximum * 360 / 180 * Math.PI);
        var pY = this.cY2 + this.R2 * Math.sin(value / maximum * 360 / 180 * Math.PI);
        this.setInnerPointer(pX, pY);
    },
    adjustOuterPointer: function(value, maximum) {
        var pX = this.cX1 - this.R1 * Math.cos(value / maximum * 360 / 180 * Math.PI);
        var pY = this.cY1 + this.R1 * Math.sin(value / maximum * 360 / 180 * Math.PI);
        this.setOuterPointer(pX, pY);
    },
    setInnerPointer: function(pX, pY) {
        this.cIn.style.marginTop = (pX - 15) + 'px';
        this.cIn.style.marginLeft = (pY - 15) + 'px';
    },
    setOuterPointer: function(pX, pY) {
        this.cOut.style.marginTop = (pX - 5) + 'px';
        this.cOut.style.marginLeft = (pY - 5) + 'px';
    },
    drawArc: function(canvas, cX, cY, radius, degree, color) {
        var ctx = canvas.getContext('2d');
        ctx.beginPath();
        ctx.strokeStyle = color;
        ctx.arc(cX, cY, radius, 1.5 * Math.PI, (degree * Math.PI / 180) + 1.5 * Math.PI, false);
        ctx.lineWidth = this.arcWidth;
        ctx.stroke();
    },
    drawInnerArc: function(canvas, cX, cY, radius, degree, color) {
        this.drawArc(canvas, cX - 5, cY - 5, radius, degree - 5, color);
    },
    drawOuterArc: function(canvas, cX, cY, radius, degree, color) {
        this.drawArc(canvas, cX + 5, cY + 5, radius, degree - 5, color);
    },
    clearCanvasArc: function(canvas) {
        var ctx = canvas.getContext('2d');
        ctx.clearRect(0, 0, this.arcCanvas.width, this.arcCanvas.height);
    },
    onMove: function(event) {},
    onChange: function(event) {}
};
var ClockSliderObject = Object.assign({
    max1: 24,
    max2: 60,
    hour: 00,
    minute: 00,
    format: 'H:M',
    c1slidecolor: 'rgba(56, 131, 37, 1)',
    c2slidecolor: 'rgba(194, 25, 25, 1)',
    init: function(containerId) {
        this.container = document.getElementById(containerId);
        for (var el of this.container.children) {
            if (el.className == 'circles-selector') {
                for (var eli of el.children) {
                    if (eli.className.baseVal == 'pointer_hours') {
                        this.cOut = eli;
                    }
                    if (eli.className.baseVal == 'pointer_minutes') {
                        this.cIn = eli;
                    }
                    if (eli.className == 'arc_canvas') {
                        this.arcCanvas = eli;
                    }
                }
                this.canvas = el;
            }
            if (el.className == 'clock') {
                this.label = el;
            }
            if (el.className == 'clock-input') {
                this.input = el;
            }
        }
        this.hour = parseInt(this.container.dataset.hour);
        this.minute = parseInt(this.container.dataset.minute);
        if (this.start != undefined) {
            var startTime = new Date('1970-01-01 ' + this.start);
            this.hour = startTime.getHours();
            this.minute = startTime.getMinutes();
        }
        this.v1 = this.hour;
        this.v2 = this.minute;
        this.adjustOuterPointer(this.v1, this.max1);
        this.adjustInnerPointer(this.v2, this.max2);
        this.drawOuterArc(this.arcCanvas, this.cX1, this.cY1, this.R1, (this.hour / this.max1 * 360), this.c1slidecolor);
        this.drawInnerArc(this.arcCanvas, this.cX2, this.cY2, this.R2, (this.minute / this.max2 * 360), this.c2slidecolor);
        this.updateScreenValues(false);
        var clockslider = this;
        this.canvas.addEventListener('mousedown', function(event) {
            clockslider.dragStart(event);
        });
        this.canvas.addEventListener('touchstart', function(event) {
            clockslider.dragStart(event);
        });
        this.canvas.addEventListener('mouseup', function(event) {
            clockslider.drageEnd(event);
        });
        this.canvas.addEventListener('mouseleave', function(event) {
            clockslider.drageEnd(event);
        });
        this.canvas.addEventListener('touchend', function(event) {
            clockslider.drageEnd(event);
        });
        this.canvas.addEventListener('mousemove', function(event) {
            clockslider.dragMove(event);
        });
        this.canvas.addEventListener('touchmove', function(event) {
            clockslider.dragMove(event);
            event.preventDefault();
        });
        return this;
    },
    update: function() {
        this.clearCanvasArc(this.arcCanvas);
        this.adjustOuterPointer(this.hour, this.max1);
        this.adjustInnerPointer(this.minute, this.max2);
        this.drawOuterArc(this.arcCanvas, this.cX1, this.cY1, this.R1, (this.hour / this.max1 * 360), this.c1slidecolor);
        this.drawInnerArc(this.arcCanvas, this.cX2, this.cY2, this.R2, (this.minute / this.max2 * 360), this.c2slidecolor);
        this.updateScreenValues();
    },
    dragStart: function(event) {
        this.inDrag = true;
    },
    dragMove: function(event) {
        if (this.inDrag) {
            event.value = this.value;
            event.hour = this.v1;
            event.minute = this.v2;
            this.onMove(event);
            if (event.defaultPrevented) {
                return;
            }
            if (event.clientX != undefined && event.clientY != undefined) {
                var pX = event.clientX;
                var pY = event.clientY;
            } else {
                var pX = event.touches[0].clientX;
                var pY = event.touches[0].clientY;
            }
            var rect = this.canvas.getBoundingClientRect();
            pX = pX - rect.left;
            pY = pY - rect.top;
            this.dragCirclePointer(pX, pY);
        }
    },
    drageEnd: function(event) {
        this.inDrag = false;
        this.dragCircle = null;
        event.value = this.value;
        event.hour = this.v1;
        event.minute = this.v2;
        this.onChange(event);
    },
    dragCirclePointer: function(pX, pY) {
        var dragValues = this.drag(pX, pY);
        if (dragValues.d1 < dragValues.d2 && dragValues.d1 < this.dragPointDistance) {
            if (this.dragCircle == 2 && this.inDrag) {
                this.dragCircle = null;
                this.inDrag = false;
                return;
            }
            this.dragCircle = 1;
            this.v1 = parseInt(dragValues.a * this.max1 / 360);
            this.hour = this.v1;
            this.v2 = this.minute;
            this.setOuterPointer(dragValues.aY1, dragValues.aX1);
            this.adjustInnerPointer(this.v2, this.max2);
            this.clearCanvasArc(this.arcCanvas);
            this.drawOuterArc(this.arcCanvas, this.cX1, this.cX1, this.R1, dragValues.a, this.c1slidecolor);
            this.drawInnerArc(this.arcCanvas, this.cX2, this.cY2, this.R2, (this.v2 / this.max2 * 360), this.c2slidecolor);
            this.updateScreenValues();
        } else if (dragValues.d2 < this.dragPointDistance) {
            if (this.dragCircle == 1 && this.inDrag) {
                this.dragCircle = null;
                this.inDrag = false;
                return;
            }
            this.dragCircle = 2;
            this.v2 = parseInt(dragValues.b * this.max2 / 360);
            this.minute = this.v2;
            this.v1 = this.hour;
            this.setInnerPointer(dragValues.aY2, dragValues.aX2);
            this.adjustOuterPointer(this.v1, this.max1);
            this.clearCanvasArc(this.arcCanvas);
            this.drawOuterArc(this.arcCanvas, this.cX1, this.cX1, this.R1, (this.v1 / this.max1 * 360), this.c1slidecolor);
            this.drawInnerArc(this.arcCanvas, this.cX2, this.cY2, this.R2, dragValues.b, this.c2slidecolor);
            this.updateScreenValues();
        }
    },
    updateScreenValues: function(updateInput = true) {
        var formattedTime = this.format;
        var v1 = (this.hour.toString().length < 2) ? '0' + this.hour : this.hour;
        var v2 = (this.minute.toString().length < 2) ? '0' + this.minute : this.minute;
        this.hour = v1;
        this.minute = v2;
        formattedTime = this.formatTime(this.format, this.hour, this.minute);
        this.label.innerHTML = formattedTime;
        this.value = formattedTime;
        if (updateInput) {
            this.input.value = formattedTime;
        }
    },
    formatTime: function(format, hour, minute) {
        var formats = {
            'H': hour,
            'M': minute
        };
        return format.replace(new RegExp(Object.keys(formats).join('|'), 'g'), function(match) {
            return formats[match];
        });
    }
}, CircleSlider);
var DateSliderObject = Object.assign({
    max1: 12,
    max2: 31,
    max3: 50,
    v3: 0,
    cTh: null,
    R3: 40,
    cX3: 110,
    cY3: 110,
    cThRounds: 0,
    dragCircle: null,
    months: [],
    days: [],
    cMonthMax: null,
    cMonthName: null,
    locale: ['en-GB', {
        weekday: 'short',
        year: 'numeric',
        month: 'short',
        day: 'numeric'
    }],
    day: 01,
    month: 01,
    year: 1970,
    date: new Date('2017-01-01'),
    format: '',
    c1slidecolor: 'rgb(255, 209, 26)',
    c2slidecolor: 'rgba(37, 24, 216, 1)',
    c3slidecolor: 'rgb(84, 104, 121)',
    dragTh: function(pX, pY) {
        var vX = pX - this.cX3;
        var vY = pY - this.cY3;
        var vSd = Math.sqrt(vX * vX + vY * vY);
        var aX3 = this.cX3 + vX / vSd * this.R3;
        var aY3 = this.cY3 + vY / vSd * this.R3;
        var vX = pX - aX3;
        var vY = pY - aY3;
        var d3 = Math.sqrt(vX * vX + vY * vY);
        var c = Math.acos((this.cY3 - aY3) / this.R3) * 180 / Math.PI;
        if (aX3 < this.cX3) {
            c = 360 - c;
        }
        var values = Object.assign(CircleSlider.drag(pX, pY), {
            'aX3': aX3,
            'aY3': aY3,
            'c': c,
            'd3': d3
        });
        return values;
    },
    adjustThPointer: function(value, maximum) {
        var pX = this.cX3 - this.R3 * Math.cos(value / maximum * 360 / 180 * Math.PI);
        var pY = this.cY3 + this.R3 * Math.sin(value / maximum * 360 / 180 * Math.PI);
        this.setThPointer(pX, pY);
    },
    setThPointer: function(pX, pY) {
        this.cTh.style.marginTop = (pX - 15) + 'px';
        this.cTh.style.marginLeft = (pY - 15) + 'px';
    },
    drawThArc: function(canvas, cX, cY, radius, degree, color) {
        this.drawArc(canvas, cX - 5, cY - 5, radius, degree - 5, color);
    },
    init: function(containerId) {
        this.container = document.getElementById(containerId);
        for (var el of this.container.children) {
            if (el.className == 'circles-selector') {
                for (eli of el.children) {
                    if (eli.className.baseVal == 'round-circles') {
                        for (var elj of eli.children) {
                            if (elj.className.baseVal == 'month-days') {
                                this.cMonthMax = elj;
                            }
                            if (elj.className.baseVal == 'month-name') {
                                this.cMonthName = elj;
                            }
                        }
                    }
                    if (eli.className.baseVal == 'pointer_months') {
                        this.cOut = eli;
                    }
                    if (eli.className.baseVal == 'pointer_days') {
                        this.cIn = eli;
                    }
                    if (eli.className.baseVal == 'pointer_years') {
                        this.cTh = eli;
                    }
                    if (eli.className == 'arc_canvas') {
                        this.arcCanvas = eli;
                    }
                }
                this.canvas = el;
            }
            if (el.className == 'date') {
                this.label = el;
            }
            if (el.className == 'date-input') {
                this.input = el;
            }
        }
        this.year = parseInt(this.container.dataset.year);
        this.month = parseInt(this.container.dataset.month) - 1;
        this.day = parseInt(this.container.dataset.day);
        if (this.start != undefined) {
            var startDate = new Date(this.start);
            this.month = startDate.getMonth();
            this.day = startDate.getDate();
            this.year = startDate.getFullYear();
        }
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
        this.date.setYear(this.year);
        for (var i = 0; i < 12; i++) {
            this.date.setMonth(i + 1, 0);
            this.months[i] = {
                name: this.date.toLocaleString(this.locale[0], {
                    month: 'long'
                }),
                sName: this.date.toLocaleString(this.locale[0], {
                    month: 'short'
                }),
                days: this.date.getDate()
            };
        }
        this.v1 = this.month;
        this.v2 = this.day;
        this.v3 = this.year % this.max3;
        this.cThRounds = parseInt(this.year / this.max3);
        this.max2 = this.months[this.month].days;
        this.adjustOuterPointer(this.month, this.max1);
        this.adjustInnerPointer(this.day, this.max2);
        this.adjustThPointer(this.year, this.max3);
        this.clearCanvasArc(this.arcCanvas);
        this.drawOuterArc(this.arcCanvas, this.cX1, this.cY1, this.R1, (this.month / this.max1 * 360), this.c1slidecolor);
        this.drawInnerArc(this.arcCanvas, this.cX2, this.cY2, this.R2, (this.day / this.max2 * 360), this.c2slidecolor);
        this.drawThArc(this.arcCanvas, this.cX3, this.cY3, this.R3, ((this.year % this.max3) / this.max3 * 360), this.c3slidecolor);
        this.updateScreenValues(false);
        var dateslider = this;
        this.canvas.addEventListener('mousedown', function(event) {
            dateslider.dragStart(event);
        });
        this.canvas.addEventListener('touchstart', function(event) {
            dateslider.dragStart(event);
        });
        this.canvas.addEventListener('mouseup', function(event) {
            dateslider.drageEnd(event);
        });
        this.canvas.addEventListener('mouseleave', function(event) {
            dateslider.drageEnd(event);
        });
        this.canvas.addEventListener('touchend', function(event) {
            dateslider.drageEnd(event);
        });
        this.canvas.addEventListener('mousemove', function(event) {
            dateslider.dragMove(event);
        });
        this.canvas.addEventListener('touchmove', function(event) {
            dateslider.dragMove(event);
            event.preventDefault();
        });
        return this;
    },
    update: function() {
        this.v2 = this.day;
        this.v1 = this.month;
        this.clearCanvasArc(this.arcCanvas);
        this.adjustOuterPointer(this.month, this.max1);
        this.adjustInnerPointer(this.day, this.max2);
        this.adjustThPointer(this.year, this.max3);
        this.clearCanvasArc(this.arcCanvas);
        this.drawOuterArc(this.arcCanvas, this.cX1, this.cY1, this.R1, (this.month / this.max1 * 360), this.c1slidecolor);
        this.drawInnerArc(this.arcCanvas, this.cX2, this.cY2, this.R2, (this.day / this.max2 * 360), this.c2slidecolor);
        this.drawThArc(this.arcCanvas, this.cX3, this.cY3, this.R3, ((this.year % this.max3) / this.max3 * 360), this.c3slidecolor);
        this.updateScreenValues();
    },
    dragStart: function(event) {
        this.inDrag = true;
    },
    dragMove: function(event) {
        if (this.inDrag) {
            event.value = this.value;
            event.day = this.day;
            event.month = this.month;
            event.year = this.year;
            this.onMove(event);
            if (event.defaultPrevented) {
                return;
            }
            if (event.clientX != undefined && event.clientY != undefined) {
                var pX = event.clientX;
                var pY = event.clientY;
            } else {
                var pX = event.touches[0].clientX;
                var pY = event.touches[0].clientY;
            }
            var rect = this.canvas.getBoundingClientRect();
            pX = pX - rect.left;
            pY = pY - rect.top;
            this.dragCirclePointer(pX, pY);
        }
    },
    drageEnd: function(event) {
        this.inDrag = false;
        this.dragCircle = null;
        event.value = this.value;
        event.day = this.day;
        event.month = this.month;
        event.year = this.year;
        this.onChange(event);
    },
    dragCirclePointer: function(pX, pY) {
        var dragValues = this.dragTh(pX, pY);
        if (dragValues.d2 > dragValues.d1 && dragValues.d3 > dragValues.d1 < this.dragPointDistance) {
            if (this.dragCircle != 1 && this.dragCircle != null && this.inDrag) {
                this.dragCircle = null;
                this.inDrag = false;
                return;
            }
            this.dragCircle = 1;
            this.v1 = parseInt(dragValues.a * this.max1 / 360);
            this.max2 = this.months[this.v1].days;
            if (this.v2 > this.max2) {
                this.v2 = this.max2;
            }
            this.day = this.v2;
            this.month = this.v1;
            this.adjustInnerPointer(this.v2, this.max2);
            this.setOuterPointer(dragValues.aY1, dragValues.aX1);
            this.adjustThPointer(this.v3, this.max3);
            this.updateScreenValues();
            this.clearCanvasArc(this.arcCanvas);
            this.drawOuterArc(this.arcCanvas, this.cX1, this.cX1, this.R1, dragValues.a, this.c1slidecolor);
            this.drawInnerArc(this.arcCanvas, this.cX2, this.cY2, this.R2, (this.v2 / this.max2 * 360), this.c2slidecolor);
            this.drawThArc(this.arcCanvas, this.cX3, this.cY3, this.R3, ((this.year % this.max3) / this.max3 * 360), this.c3slidecolor);
        } else if (dragValues.d1 > dragValues.d2 && dragValues.d3 > dragValues.d2 && dragValues.d2< this.dragPointDistance) {
            if (this.dragCircle != 2 && this.dragCircle != null&& this.inDrag) {
                this.dragCircle = null;
                this.inDrag = false;
                return;
            }
            this.dragCircle = 2;
            this.v2 = parseInt(dragValues.b * this.max2 / 360) + 1;
            this.day = this.v2;
            this.month = this.v1;
            this.setInnerPointer(dragValues.aY2, dragValues.aX2);
            this.adjustOuterPointer(this.v1, this.max1);
            this.adjustThPointer(this.v3, this.max3);
            this.updateScreenValues();
            this.clearCanvasArc(this.arcCanvas);
            this.drawOuterArc(this.arcCanvas, this.cX1, this.cX1, this.R1, (this.v1 / this.max1 * 360), this.c1slidecolor);
            this.drawInnerArc(this.arcCanvas, this.cX2, this.cY2, this.R2, dragValues.b, this.c2slidecolor);
            this.drawThArc(this.arcCanvas, this.cX3, this.cY3, this.R3, ((this.year % this.max3) / this.max3 * 360), this.c3slidecolor);
        } else if (dragValues.d1 > dragValues.d3 && dragValues.d2 > dragValues.d3 && dragValues.d3 < this.dragPointDistance) {
            if (this.dragCircle != 3 && this.dragCircle != null && this.inDrag) {
                this.dragCircle = null;
                this.inDrag = false;
                return;
            }
            this.dragCircle = 3;
            if ((this.v3 / this.max3 * 360 - parseInt(dragValues.c)) > 180) {
                this.cThRounds++;
            }
            if ((this.v3 / this.max3 * 360 - parseInt(dragValues.c)) < -180) {
                this.cThRounds--;
            }
            this.v3 = parseInt(dragValues.c * this.max3 / 360);
            this.year = this.v3 + this.max3 * this.cThRounds;
            if (this.year % 4 == 0) {
                this.months[1].days = 29;
            } else if (this.year % 4 == 1 || this.year % 4 == 3) {
                this.months[1].days = 28;
            }
            if (this.month == 1) {
                this.max2 = this.months[this.month].days;
            }
            if (this.day > this.max2) {
                this.day = this.max2;
            }
            this.day = this.v2;
            this.month = this.v1;
            this.setInnerPointer(this.v2, this.max2);
            this.setThPointer(dragValues.aY3, dragValues.aX3);
            this.adjustOuterPointer(this.v1, this.max1);
            this.adjustInnerPointer(this.v2, this.max2);
            this.updateScreenValues();
            this.clearCanvasArc(this.arcCanvas);
            this.drawOuterArc(this.arcCanvas, this.cX1, this.cX1, this.R1, (this.v1 / this.max1 * 360), this.c1slidecolor);
            this.drawInnerArc(this.arcCanvas, this.cX2, this.cY2, this.R2, (this.v2 / this.max2 * 360), this.c2slidecolor);
            this.drawThArc(this.arcCanvas, this.cX3, this.cY3, this.R3, dragValues.c, this.c3slidecolor);
        }
    },
    updateScreenValues: function(updateInput = true) {
        var v1 = ((this.month + 1).toString().length < 2) ? '0' + (this.month + 1) : (this.month + 1);
        var v2 = (this.day.toString().length < 2) ? '0' + this.day : this.day;
        if (this.year > 9999) {
            this.year = 9999;
        }
        var offsetLength = 4 - this.year.toString().length;
        for(var i = 0; i < offsetLength; i++) {
            this.year = '0' + this.year;
        }
        this.date = new Date(this.year + '-' + v1 + '-' + v2);
        var formattedDate = this.format;
        var monthName = this.months[this.month].sName;
        if (this.locale != undefined) {
            if (this.format == '') {
                formattedDate = this.date.toLocaleDateString(this.locale[0], this.locale[1]);
            }
        }
        if (this.format != '') {
            formattedDate = this.formatDate(formattedDate, v2, v1, this.year);
        }
        this.cMonthMax.innerHTML = this.max2;
        this.cMonthName.innerHTML = monthName;
        this.label.innerHTML = formattedDate;
        this.value = formattedDate;
        if (updateInput) {
            this.input.value = this.formatDate('y-m-d', v2, v1, this.year);
        }
    },
    formatDate: function(format, day, month, year) {
        var date = new Date(year + '-' + month + '-' + day);
        var formats = {
            'd': day,
            'a': this.days[date.getDay()].sName,
            'A': this.days[date.getDay()].name,
            'b': this.months[month - 1].sName,
            'B': this.months[month - 1].name,
            'm': month,
            'y': year
        };
        return format.replace(new RegExp(Object.keys(formats).join('|'), 'g'), function(match) {
            return formats[match];
        });
    }
}, CircleSlider);

function ClockSlider(containerId, options = {}) {
    var obj = Object.create(Object.assign(ClockSliderObject, options));
    return obj.init(containerId);
}

function DateSlider(containerId, options = {}) {
    var obj = Object.create(Object.assign(DateSliderObject, options));
    return obj.init(containerId);
}
