import React from 'react';
import ReactDOM from 'react-dom';
//discussed with cheng Zeng
export default function form_init(root) {
    ReactDOM.render(<Form/>, root);
}

class Form extends React.Component {
    

    render() {
        return (
            <div>
                    <div>
                        <input type="text"
                            id="game-name" placeholder="Input Name of Game">
                        </input>
                    </div>
                    <Submit/>
            </div>

        );
    }
}

function Submit() {
    return(
        <button type="button" className="btn btn-primary"
                onClick={
                    () => {
                        let name = $("#game-name").val();
                        if (name != "") {
                            window.location = "/game/"+name;
                        }
                    }
                }>Join Game Now</button>
    );
}
