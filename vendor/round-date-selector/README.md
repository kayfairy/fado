# Round Date Selector

![image](https://user-images.githubusercontent.com/53660340/62415134-36be5800-b625-11e9-901c-9eb378d30fe8.png)

Drag pointers until desired date and time gets displayed.

<https://jsfiddle.net/3j2gpqsy/>

## Usage

Change values at start, setting the data attributes for each canvas or setting the option `start`.

```html
<div id="calendar-container-id" class="round-date-selector" data-year="2013" data-month="4" data-day="16">
[...]
</div>

<div id="clock-container-id" class="round-date-selector" data-hour="8" data-minute="13">
[...]
</div>

<script>
    var dateSlider = DateSlider('calendar-container-id', {option: 'value'});
    var clockSlider = ClockSlider('clock-container-id', {option: 'value'});
</script>
```

## Options

Option `start` can contain values accepted by `Date.parse()`. `start` option of `Clockslider` does not need a preceding date.

Set `locale` option to change language. Valid options are parameters of `Date.toLocaleDateString()`.

Add `format` option if necessary. Following characters inside the format string get replaced:

| format character | value                                  |
| ---------------- | -------------------------------------- |
| `d`              | `day` [01-31]                          |
| `m`              | `month` [01-12]                        |
| `y`              | `year`                                 |
| `b`              | `month` _short name_ [Jan-Dec]         |
| `B`              | `month` _long name_ [January-December] |
| `a`              | `day` _short name_ [Mon-Sun]           |
| `A`              | `day` _long name_ [Monday-Sunday]      |
| `H`              | `hour` [00-23]                         |
| `M`              | `minute` [00-59]                       |

Events available are `onMove` and `onChange`.

```javascript
DateSlider(
    'calendar-container-id',
    {
        start: '21 Oct 2011',
        locale: ['en-US', {weekday: 'short', year: 'numeric', month: 'short', day: 'numeric'}],
        format: 'a, d. b y',
        onChange: function (event) {
            console.log(event.value, event.day, event.month, event.year);
        }
    }
);

ClockSlider(
    'clock-container-id',
    {
        start: '00:00',
        format: 'Hh Mm',
        onMove: function (event) {
            event.preventDefault();
            console.log(event.value, event.hour, event.minute);
        }
    }
);
```

## Form values

Selected date and time values are stored inside input fields as ISO 8601 format. Years from 1 to 9999.

```html
<input class="date-input" type="hidden" name="date" value="2013-08-14">

<input class="clock-input" type="hidden" name="time" value="03:00">
```

## Appearance

Modify colors by changing svg attributes `stroke`, `fill` and setting options `c1slidecolor`, `c2slidecolor` on `ClockSlider`.

```html
<circle cx="105" cy="105" r="80" stroke="darkolivegreen" stroke-width="1" fill="white" />

<script>
ClockSlider(
    'clock-container-id',
    {
        c1slidecolor: 'rgba(56, 131, 37, 1)',
        c2slidecolor: 'rgba(194, 25, 25, 1)'
    }
);
</script>
```

## Show current time

Disable selector and adjust current time every 1 second.

```javascript
var dateSlider = DateSlider('calendar-container-id', {
    onMove: function (event) {
        event.preventDefault();
    }
});
var clockSlider = ClockSlider('clock-container-id', {
    onMove: function (event) {
        event.preventDefault();
    }
});
function setDate(date) {
    clockSlider.hour = date.getHours();
    clockSlider.minute = date.getMinutes();
    clockSlider.update();
    dateSlider.day = date.getDate();
    dateSlider.month = date.getMonth();
    dateSlider.year = date.getFullYear();
    dateSlider.update();
}
setDate(new Date());
setInterval(function () { setDate(new Date()); }, 1000);
```

## License

[GPLv3 License](https://www.gnu.org/licenses/gpl-3.0.en.html) © 2019 Fatih Kaymak
